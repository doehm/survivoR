#' Confessional time
#'
#' @param path Parent director where the files are stored. This parth should include 3 sub-directories
#' Final, Staging and Notes.
#' @param .vs Version season
#' @param .episode Episode
#' @param folder The folder to read the text file. Default is 'Final'
#'
#' @return data frame
#' @export
get_confessional_timing <- function(
    path,
    .vs,
    .episode,
    folder = "Final"
) {

  .vse <- paste0(.vs, str_pad(.episode, side = "left", width = 2, pad = 0))
  files <- list.files(file.path(path, folder), pattern = .vse, full.names = TRUE)
  df_time <- map_dfr(files, ~{
    read_csv(.x, col_types = cols(), col_names = FALSE) |>
      mutate(file_id = which(files == .x)) |>
      set_names(c("id", "castaway", "action", "time", "file_id"))
  }) |>
    mutate(id = glue("ID{str_pad(file_id, side = 'left', width = 2, pad = 0)}{str_pad(id, side = 'left', width = 3, pad = 0)}")) |>
    group_by(castaway, id) |>
    filter(n() > 1) |>
    pivot_wider(names_from = action, values_from = time) |>
    mutate(
      duration = as.numeric(difftime(stop, start, units = "secs")),
      duration = replace_na(duration, 5)
    )

  df_conf <- df_time |>
    arrange(castaway, start, stop) |>
    group_by(castaway) |>
    mutate(
      time_between = as.numeric(difftime(start, lag(stop), units = "secs")),
      time_between = replace_na(time_between, 9999),
      confessional_count = as.numeric(time_between > 10)
    ) |>
    summarise(confessional_count = sum(confessional_count))

  # check for in progress seasons
  in_progress_vs <- readLines("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/vs.txt")

  if(.vs %in% in_progress_vs) {
    online_file <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}.csv")
    online_file_castaways <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}-castaways.csv")
    df_boot_mapping <- read_csv(online_file, show_col_types = FALSE)
    df_castaways <- read_csv(online_file_castaways, show_col_types = FALSE)
  } else {
    df_boot_mapping <- survivoR::boot_mapping
    df_castaways <- survivoR::castaways
  }

  df_boot_mapping |>
    filter(
      version_season == .vs,
      episode == .episode
    ) |>
    distinct(version_season, episode, castaway_id, castaway) |>
    left_join(
      df_time |>
        group_by(castaway) |>
        summarise(confessional_time = sum(duration)) |>
        mutate(
          version_season = .vs,
          episode = .episode
        ) |>
        left_join(
          df_castaways |>
            filter(version_season == .vs) |>
            distinct(castaway, castaway_id),
          by = "castaway"
        ) |>
        select(version_season, episode, castaway_id, castaway, confessional_time),
      by = c("version_season", "episode", "castaway_id", "castaway")
    ) |>
    left_join(df_conf, by = "castaway") |>
    mutate(
      confessional_time = replace_na(confessional_time, 0),
      confessional_count = replace_na(confessional_count, 0)
    )

}
