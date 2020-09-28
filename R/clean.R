#' Clean cast data
#'
#' @param df Data frame
#' @param season Season number
#' @param season_name Season name
#'
#' @return
#' @export
#'
#' @examples \dontrun{}
clean_cast <- function(df, season, season_name) {
  df %>%
    mutate(
      contestant = str_replace(contestant, " †", ""),
      contestant = str_replace(contestant, "†", ""),
      first_name = str_extract(contestant, "[:alnum:]+\\s|[:alnum:]+-[:alnum:]+"),
      last_name = str_extract(contestant, "\\s[:alnum:]+,|\\s[:alnum:]+(-|'|\\s)[:alnum:]+,|\\s[:alnum:]+(-|'|\\s)[:alnum:]+(-|'[:alpha:]+|\\.)[:digit:]+,"),
      last_name = ifelse(is.na(last_name), str_extract(contestant, "\\s[:alnum:]+Returned to game|\\s[:alnum:]+(-|')[::alnum]Returned to game"), last_name),
      age = str_extract(last_name, "[:digit:]+"),
      last_name = str_replace(last_name, "[:digit:]+,", ""),
      last_name = str_replace(last_name, "Returned to game", ""),
      first_name = str_trim(first_name),
      last_name = str_trim(last_name),
      castaway = glue("{first_name} {last_name}"),
      nickname = str_replace_all(str_extract(contestant, '".+"'), '"', ""),
      nickname = str_replace(nickname, "The ", ""),
      nickname = ifelse(is.na(nickname), first_name, nickname),
      merged_tribe = ifelse(str_detect(merged_tribe, "None"), NA, merged_tribe),
      merged_tribe = str_replace(merged_tribe, "\\[[:alpha:]\\]", ""),
      merged_tribe = ifelse(merged_tribe == "", NA, merged_tribe),
      original_tribe = str_replace(original_tribe, "\\[[:alpha:]\\]", ""),
      original_tribe = ifelse(original_tribe == "", NA, original_tribe),
      day = as.numeric(str_extract(str_extract(result, "Day [:digit:]+"), "[:digit:]+")),
      day = ifelse(is.na(day), 39, day),
      voted_out = str_extract(result, "[:digit:]+(st|th|nd|rd) voted out"),
      jury_status = str_extract(result, "[:digit:]+(st|th|nd|rd) jury member"),
      ejected = str_extract(result, "Ejected"),
      eliminated = str_extract(result, "Eliminated"),
      sole_survivor = str_extract(result, "Sole Survivor"),
      medical = str_extract(result, "Medically evacuated"),
      runner_up = str_extract(result, ".+unner-up"),
      quit = str_extract(result, "Quit"),
      withdrew = str_extract(result, "Withdr[:alpha:]+"),
      switched = str_extract(result, "Switched"),
      season = season,
      season_name = season_name,
      result = coalesce(voted_out, runner_up, ejected, eliminated, sole_survivor, medical, withdrew, quit, switched),
      order = 1:n(),
      castaway = as.character(castaway)
    ) %>%
    {if("swapped_tribe" %in% colnames(.)) {
      mutate(.,
             swapped_tribe = ifelse(str_detect(swapped_tribe, "None"), NA, swapped_tribe),
             swapped_tribe = ifelse(swapped_tribe == "", NA, swapped_tribe),
             swapped_tribe = str_replace(swapped_tribe, "\\[[:alpha:]\\]", "")
      )
    } else .
    } %>%
    {if("swapped_tribe2" %in% colnames(.)) {
      mutate(.,
        swapped_tribe2 = ifelse(str_detect(swapped_tribe2, "None"), NA, swapped_tribe2),
        swapped_tribe2 = ifelse(swapped_tribe2 == "", NA, swapped_tribe2),
        swapped_tribe2 = str_replace(swapped_tribe2, "\\[[:alpha:]\\]", "")
        )
      } else .
    } %>%
    select(
      season_name, season, castaway, nickname, age, day, original_tribe, contains("swapped_tribe"),
      merged_tribe, result, jury_status, order
    )
}


#' Clean vote history data
#'
#' @param df Data frame
#' @param season Season number
#' @param season_name Season name
#'
#' @return
#' @export
#'
#' @examples \dontrun{}
clean_vote_matrix <- function(df, season, season_name, extra_cols = NULL) {
  df <- df[, !is.na(df[1,])]
  first_cols <- 1:sum(str_detect(df[1,], "Episode"))
  last_cols <- c(extra_cols, (ncol(df)-sum(is.na(df[1,]))):ncol(df))
  episode <- as.numeric(df[1,-c(first_cols, last_cols)])
  day <- as.numeric(str_extract(df[2,-c(first_cols, last_cols)], "[:digit:]+"))
  tribe <- colnames(df)[-c(first_cols, last_cols)]
  tribe <- tolower(to_parsed_case(tribe))
  tribe <- str_replace(tribe, "_[:digit:]+", "")
  tribe <- str_replace(tribe, "tribes", "tribe")
  tie <- str_extract(df[3, -c(first_cols, last_cols)], "Tie")
  voted_out <- as.character(df[3,-c(first_cols, last_cols)])
  voted_out <- ifelse(str_detect(voted_out, "Tie"), glue("-{voted_out}-"), voted_out)
  order <- tibble(voted_out = unique(voted_out[!str_detect(voted_out, "Tie")]), order = 1:length(voted_out))
  final_cols <- c(first_cols[-max(first_cols)], last_cols)

  df[-c(1:6), -final_cols] %>%
  set_names(c("voter", paste("id", 1:length(day)))) %>%
  pivot_longer(cols = -voter, names_to = "id", values_to = "vote") %>%
    mutate(
      vote = ifelse(vote == "", NA, vote),
      # vote = ifelse(str_detect(vote, "Immune|Saved|None|Lose|Win|Exiled"), NA, vote),
      vote = str_replace(vote, "\\[[:alpha:]\\]", "")
    ) %>%
    left_join(tibble(day = day, episode = episode, tribe_status = tribe, voted_out = voted_out, id = paste("id", 1:length(day))), by = "id") %>%
    mutate(
      season = season,
      season_name = season_name
    ) %>%
    rename(castaway = voter) %>%
    select(season_name, season, episode, day, castaway, tribe_status, vote, voted_out) %>%
    distinct() %>%
    left_join(order, by = "voted_out")
}


#' Clean vote history data
#'
#' @param df Data frame
#'
#' @return
#' @export
#'
#' @examples \dontrun{}
extract_vote_data <- function(df) {
  vm_cols <- which(!is.na(df[3,]))
  vm_rows <- which(str_detect(df[2:5,1], "Episode")):(which(df[,1] == "Jury vote")-1)
  jury_vote <- which(df[,1] == "Jury vote")
  jv_cols <- which(!is.na(df[jury_vote,]))
  jv_rows <- jury_vote:nrow(df)
  jury_vote_data <- df[jv_rows, jv_cols] %>%
    slice(2:n())

  list(
    vote_matrix_data = df[vm_rows, vm_cols],
    jury_vote_data = jury_vote_data
  )
}



#' Clean jury vote data
#'
#' @param df Data frame
#' @param season Season number
#' @param season_name Season name
#'
#' @return
#' @export
#'
#' @examples \dontrun{}
clean_jury_votes <- function(df, season, season_name) {

  col_x <- as.character(df[3,])
  col_x <- col_x[col_x != "NA"]
  col_x <- col_x[!is.na(col_x)]
  df_x <- df[(which(str_detect(df[,1], "Juror"))+1):nrow(df),1:length(col_x)]

  df_x %>%
    set_names(col_x) %>%
    select(all_of(col_x)) %>%
    rename(castaway = Finalist) %>%
    pivot_longer(cols = -castaway, names_to = "finalist", values_to = "vote") %>%
    mutate(
      vote = as.numeric(finalist == vote),
      castaway = str_replace(castaway, "\\[[:alpha:]\\]", ""),
      finalist = str_replace(finalist, "\\[[:alpha:]\\]", ""),
      season = season,
      season_name = season_name
    ) %>%
    select(season_name, season, everything())
}



#' Clean viewers data
#'
#' @param df Data frame
#' @param season Season number
#' @param season_name Season name
#'
#' @return
#' @export
#'
#' @examples \dontrun{}
clean_viewers <- function(df, season, season_name) {
  df %>%
    clean_names() %>%
    rename(episode = no) %>%
    mutate(
      season = season,
      season_name = season_name
      ) %>%
    select(season, season_name, episode, title, air_date, total_viewers_millions)
}



#' Clean challenges data
#'
#' @param df Data frame
#' @param season Season number
#' @param season_name Season name
#'
#' @return
#' @export
#'
#' @examples \dontrun{}
clean_challenges <- function(df, season, season_name) {
  df %>%
    as_tibble() %>%
    clean_names() %>%
    set_names(c("episode", "title", "reward", "immunity", "voted_out")) %>%
    mutate(
      reward = ifelse(str_detect(reward, "None"), NA, reward),
      reward = str_replace_all(reward, "\\[[:alpha:]\\]", ""),
      reward = str_replace_all(reward, "\\[", ","),
      reward = str_replace_all(reward, ",+", ","),
      reward = str_replace_all(reward, "\\]", ""),
      reward = ifelse(str_detect(reward, "[:digit:]"), NA, reward),
      immunity = str_replace_all(immunity, "\\[[:alpha:]\\]", ""),
      immunity = str_replace_all(immunity, "\\[", ","),
      immunity = str_replace_all(immunity, "\\]", ""),
      immunity = str_replace_all(immunity, "\\(", ","),
      immunity = str_replace_all(immunity, "\\)", ""),
      immunity = str_extract(immunity, "([:alpha:]|\\s|\\.)+"),
      title = str_replace_all(title, '"', ''),
      episode = as.numeric(episode),
      season = season,
      season_name = season_name,
      voted_out = str_replace(voted_out, "\\[[:alpha:]\\]", "")
    ) %>%
    select(season_name, season, everything())
}


#' Clean immunity data
#'
#' @param df Data frame
#'
#' @return
#' @export
#'
#' @examples \dontrun{}
clean_immunity <- function(df) {
  df %>%
    distinct(season_name, season, episode, title, immunity, voted_out) %>%
    nest(immunity = immunity)
}


#' Clean rewards data
#'
#' @param df Data frame
#'
#' @return
#' @export
#'
#' @examples \dontrun{}
clean_rewards <- function(df) {
  df %>%
    distinct(season_name, season, episode, title, reward) %>%
    mutate(reward = str_split(reward, ",")) %>%
    unnest(cols = reward) %>%
    nest(reward = reward)
}
