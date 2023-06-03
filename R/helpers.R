utils::globalVariables(c("action", "castaway", "castaway_id", "confessional_count", "confessional_time",
                         "duration", "episode", "start", "time", "time_between", "version_season",
                         "season_summary"))

#' Show a season logo palette
#'
#' Easily view a palette for a given season and version including the log for reference
#'
#' @param version_season The version / season key e.g. `US42`
#' @param type Either `logo` or `tribe`. Currently only for `logo`
#' @param n The number of colours to view in the palette
#'
#' @return A ggplot2 graphic with the palette and logo
#' @export
#'
#' @importFrom glue glue
#' @importFrom prismatic color
#'
#' @examples
#'
#' show_palette("US43", n = 6)
show_palette <- function(version_season, n = NULL, type = "logo") {

  pal <- survivoR::season_palettes$palette[survivoR::season_palettes$version_season == version_season]
  if(length(pal) == 0) stop(glue("No logo for {version_season}\n"))

  if(is.null(n)) {
    n <- length(pal)
  } else {
    pal <- colorRampPalette(pal)(n)
  }

  x1 <- seq(0, 1-1/n, 1/n)
  x2 <- x1 + 1/n

  print(prismatic::color(pal))
  cat("\nCopy paste \u2192 ", paste0("c('", paste0(pal, collapse = "', '"), "')\n"))

  ggplot(tibble(x1, x2)) +
    geom_rect(aes(xmin = x1, xmax = x2, ymin = 0, ymax = 1), fill = pal) +
    ggpath::geom_from_path(aes(0.5, 0.5, path = glue::glue("https://gradientdescending.com/survivor/logos-clean/{version_season}.png")), width = 0.45) +
    theme_void()

}


#' Castaway images
#'
#' Returns the URL for the image of the specified castaways by their `castaway_id`
#' and season / version they were in
#'
#' @param castaway_ids Castaway ID
#' @param version_season Version season key for the season they played
#'
#' @return Character vector of URLs
#' @export
#'
#' @examples
#' library(dplyr)
#'
#' survivoR::castaways %>%
#'   filter(version_season == "US42") %>%
#'   mutate(castaway_image = get_castaway_image(castaway_id, version_season))
get_castaway_image <- function(castaway_ids, version_season) {
  glue::glue("https://gradientdescending.com/survivor/castaways/colour/{version_season}{castaway_ids}.png")
}

#' Launch Confessional App
#'
#' Launches the confessional timing app in either a browser or viewer. Default is set to
#' browser. The user is required to provide a path for which the time stanps are recoreded.
#'
#' @param path Parent director for where the files will be saved.
#' @param browser Open in browser instead of viewer. Default \code{TRUE}
#'
#' @return Shiny app
#' @export
#'
#' @importFrom purrr set_names
#' @import shiny
#'
#' @examples
#' \dontrun{
#'
#' # launch app
#' launch_confessional_app('timing')
#'
#' }
#'
launch_confessional_app <- function(path, browser = TRUE) {

  confApp <<- new.env()
  confApp$default_path <- file.path(getwd(), path)
  confApp$start_season <- max(survivoR::season_summary$season)

  shiny::runApp(
    file.path(system.file(package = "survivoR"), "confessionalDash"),
    launch.browser = browser
    )
}

#' Confessional time
#'
#' Takes the output of the times recorded from the Shiny app and aggregates to the final
#' confessional times and confessional counts. \code{confessional_time} is the total duration
#' in seconds for the episode. \code{confessional_count} is the number of confessionals
#' recorded to be at least 10 seconds apart.
#'
#' @param paths Paths to the csv file containing all the time stamps from the Shiny app
#' @param .vs Version season
#' @param .episode Episode
#'
#' @return data frame
#' @export
#'
#' @import dplyr
#' @importFrom purrr map_dfr
#' @importFrom stringr str_pad
#' @importFrom readr read_csv cols
#'
#'
#' @examples
#' # After running app and recording confessionals, run...
#' # Example from a saved timing file
#'
#' path <- system.file(package = "survivoR", "confessionalDash/US4412.csv")
#' get_confessional_timing(path = path, .vs = "US44", .episode = 12)
get_confessional_timing <- function(
    paths,
    .vs,
    .episode
) {

  .vse <- paste0(.vs, str_pad(.episode, side = "left", width = 2, pad = 0))
  files <- paths
  df_time <- map_dfr(files, ~{
    read_csv(.x, col_types = cols(), col_names = FALSE) %>%
      mutate(file_id = which(files == .x)) %>%
      set_names(c("id", "castaway", "action", "time", "file_id"))
  }) %>%
    mutate(id = glue("ID{str_pad(file_id, side = 'left', width = 2, pad = 0)}{str_pad(id, side = 'left', width = 3, pad = 0)}")) %>%
    group_by(castaway, id) %>%
    filter(n() > 1) %>%
    pivot_wider(names_from = action, values_from = time) %>%
    mutate(
      duration = as.numeric(difftime(stop, start, units = "secs")),
      duration = replace_na(duration, 5)
    )

  df_conf <- df_time %>%
    arrange(castaway, start, stop) %>%
    group_by(castaway) %>%
    mutate(
      time_between = as.numeric(difftime(start, lag(stop), units = "secs")),
      time_between = replace_na(time_between, 9999),
      confessional_count = as.numeric(time_between > 10)
    ) %>%
    summarise(confessional_count = sum(confessional_count))

  # check for in progress seasons
  if(!.vs %in% season_summary$version_season) {
    in_progress_vs <- readLines("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/vs.txt")
    online_file <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}.csv")
    online_file_castaways <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}-castaways.csv")
    df_boot_mapping <- read_csv(online_file, show_col_types = FALSE)
    df_castaways <- read_csv(online_file_castaways, show_col_types = FALSE)
  } else {
    df_boot_mapping <- survivoR::boot_mapping
    df_castaways <- survivoR::castaways
  }

  df_boot_mapping %>%
    filter(
      version_season == .vs,
      episode == .episode
    ) %>%
    distinct(version_season, episode, castaway_id, castaway) %>%
    left_join(
      df_time %>%
        group_by(castaway) %>%
        summarise(confessional_time = sum(duration)) %>%
        mutate(
          version_season = .vs,
          episode = .episode
        ) %>%
        left_join(
          df_castaways %>%
            filter(version_season == .vs) %>%
            distinct(castaway, castaway_id),
          by = "castaway"
        ) %>%
        select(version_season, episode, castaway_id, castaway, confessional_time),
      by = c("version_season", "episode", "castaway_id", "castaway")
    ) %>%
    left_join(df_conf, by = "castaway") %>%
    mutate(
      confessional_time = replace_na(confessional_time, 0),
      confessional_count = replace_na(confessional_count, 0)
    )

}

