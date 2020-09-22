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
      first_name = str_extract(contestant, "[:alnum:]+\\s"),
      last_name = str_extract(contestant, "\\s[:alnum:]+,|\\s[:alnum:]+(-|')[:alnum:]+,"),
      last_name = ifelse(is.na(last_name), str_extract(contestant, "\\s[:alnum:]+Returned to game|\\s[:alnum:]+(-|')[::alnum]Returned to game"), last_name),
      age = str_extract(last_name, "[:digit:]+"),
      last_name = str_replace(last_name, "[:digit:]+,", ""),
      last_name = str_replace(last_name, "Returned to game", ""),
      first_name = str_replace_all(first_name, " ", ""),
      last_name = str_replace_all(last_name, " ", ""),
      castaway = glue("{first_name} {last_name}"),
      nickname = str_replace_all(str_extract(contestant, '".+"'), '"', ""),
      nickname = str_replace(nickname, "The ", ""),
      nickname = ifelse(is.na(nickname), first_name, nickname),
      swapped_tribe = ifelse(str_detect(swapped_tribe, "None"), NA, swapped_tribe),
      swapped_tribe = ifelse(swapped_tribe == "", NA, swapped_tribe),
      merged_tribe = ifelse(merged_tribe %in% c("None[d]", ""), NA, merged_tribe),
      merged_tribe = ifelse(str_detect(merged_tribe, "None"), NA, merged_tribe),
      voted_out = str_extract(result, "[:digit:]+(st|th|nd|rd) voted out"),
      jury_status = str_extract(result, "[:digit:]+(st|th|nd|rd) jury member"),
      ejected = str_extract(result, "Ejected"),
      eliminated = str_extract(result, "Eliminated"),
      sole_survivor = str_extract(result, "Sole Survivor"),
      medical = str_extract(result, "Medical.+"),
      runner_up = str_extract(result, ".+unner-up"),
      quit = str_extract(result, "Quit.+"),
      season = season,
      season_name = season_name,
      result = coalesce(voted_out, runner_up, ejected, eliminated, sole_survivor, medical),
      order = 1:n()
    ) %>%
    select(
      season_name, season, castaway, nickname, age, original_tribe, swapped_tribe,
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
  # browser()
  first_cols <- 1:sum(str_detect(df[1,], "Episode"))
  last_cols <- c(extra_cols, (ncol(df)-sum(is.na(df[1,]))):ncol(df))
  episode <- as.numeric(df[1,-c(first_cols, last_cols)])
  day <- as.numeric(str_extract(df[2,-c(first_cols, last_cols)], "[:digit:]+"))
  tie <- str_extract(df[3, -c(first_cols, last_cols)], "Tie")
  voted_out <- as.character(df[3,-c(first_cols, last_cols)])
  voted_out <- ifelse(str_detect(voted_out, "Tie"), "-Tie-", voted_out)
  order <- tibble(voted_out = unique(voted_out[voted_out != "-Tie-"]), order = 1:length(voted_out))
  final_cols <- c(first_cols[-max(first_cols)], last_cols)

  df[-c(1:6), -final_cols] %>%
  set_names(c("voter", paste("id", 1:length(day)))) %>%
  pivot_longer(cols = -voter, names_to = "id", values_to = "vote") %>%
    mutate(
      vote = ifelse(vote == "", NA, vote),
      vote = ifelse(str_detect(vote, "Immune|Saved|None|Lose|Win|Exiled"), NA, vote),
      vote = str_replace(vote, "\\[[:alpha:]\\]", "")
    ) %>%
    left_join(tibble(day = day, episode = episode, voted_out = voted_out, id = paste("id", 1:length(day))), by = "id") %>%
    mutate(
      season = season,
      season_name = season_name
    ) %>%
    rename(castaway = voter) %>%
    select(season_name, season, episode, day, castaway, vote, voted_out) %>%
    distinct() %>%
    left_join(order, by = "voted_out")
}



#' Clean jury vote data
#'
#' @param df Data frame
#' @param col_x Columns that contain the finalists names
#' @param season Season number
#' @param season_name Season name
#'
#' @return
#' @export
#'
#' @examples \dontrun{}
clean_jury_votes <- function(df, col_x, season, season_name) {
  df[,1:4] %>%
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
      immunity = str_extract(immunity, "[:alpha:]+"),
      title = str_replace_all(title, '"', ''),
      episode = as.numeric(episode),
      season = season,
      season_name = season_name
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
