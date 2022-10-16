#' Launch Confessional App
#'
#' Opens a viewer or browser to time castaway confessionals
#'
#' @param browser Open in browser instead of viewer. Logical.
#'
#' @return Shiny app
#' @export
launch_confessional_app <- function(browser = FALSE) {
  shiny::runApp(file.path(system.file(package = "survivoR"), "confessionalDash"))
}

#' Set the default path
#'
#' Sets the default path of the output files for the confessional app
#'
#' @param path The desired default path
#'
#' @return Nothing
#' @export
set_default_path <- function(path) {
  if(!exists("confApp")) {
    confApp <- new.env()
  }
  confApp$default_path <- path
  save(confApp,file = paste0(system.file(package = "survivoR"), "/confessionalDash/env.rda"))
  cat(crayon::green("Confessional App default path saved\n"))
}

#' Confessional time
#'
#' @param .vs Version season
#' @param .episode Episode
#'
#' @return data frame
#' @export
get_confessional_timing <- function(
    .vs,
    .episode,
    folder = "Final",
    path = NULL
) {

  if(is.null(path)) {
    env_file <- file.path(system.file(package =  "survivoR"), "confessionalDash/env.rds")
    if(file.exists(env_file)) {
      readRDS(env_file)
      path <- confApp$default_path
    } else {
      stop("No path provided\n")
    }
  }

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
      duration = as.numeric(stop - start),
      duration = replace_na(duration, 5)
    )

  df_conf <- df_time |>
    arrange(castaway, start, stop) |>
    group_by(castaway) |>
    mutate(
      time_between = as.numeric(start - lag(stop)),
      time_between = replace_na(time_between, 9999),
      confessional_count = as.numeric(time_between >= 10)
    ) |>
    summarise(confessional_count = sum(confessional_count))

  survivoR::boot_mapping |>
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
          survivoR::castaways |>
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
