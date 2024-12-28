# assigning global variables
utils::globalVariables(c("action", "castaway", "castaway_id", "confessional_count", "confessional_time",
                         "duration", "episode", "start", "time", "time_between", "version_season",
                         "season_summary", "n_start", "n_stop", "global_id", "id0", "confApp",
                         "original_tribe", "season", "tribe_colour", "tribe_status", "value",
                         "num", "tribe", "change_castaway"))

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
#' browser. The user is required to provide a path for which the time stamps are recorded.
#'
#' @param browser Open in browser instead of viewer. Default \code{TRUE}
#' @param path Parent directory for output files. Default is a sub-folder \code{'confessional-timing'}
#' in the current working directory.
#' @param write Write to disc. Default \code{TRUE}.
#'
#' @return An active R shiny application
#' @export
#'
#' @importFrom purrr set_names map
#' @importFrom shinycssloaders withSpinner
#' @importFrom readr read_csv write_csv write_lines
#' @importFrom shinyjs extendShinyjs useShinyjs
#' @importFrom DT datatable renderDT DTOutput
#' @importFrom crayon green
#' @importFrom lubridate now
#' @import shiny
#'
#' @examples
#' ## Only run this example in interactive R sessions
#'
#' if(interactive()) {
#'
#'   # launch app
#'   # launch_confessional_app()
#'
#' }
#'
launch_confessional_app <- function(browser = TRUE, path = NULL, write = TRUE) {

  confApp <<- new.env()
  confApp$default_path <- ifelse(is.null(path), file.path(getwd(), "confessional-timing"), path)
  confApp$allow_write <- write

  app <- shinyApp(conf_app_ui, conf_app_server)
  runApp(app, launch.browser = browser)

}

#' Confessional time
#'
#' Takes the output of the times recorded from the Shiny app and aggregates to the final
#' confessional times and confessional counts. \code{confessional_time} is the total duration
#' in seconds for the episode. \code{confessional_count} is the number of confessionals
#' recorded to be at least 10 seconds apart.
#'
#' @param x Either a data frame or path(s) to the csv file containing all the time stamps from the Shiny app
#' @param .vs Version season
#' @param .episode Episode
#' @param .mda Missing duration adjustment (MDA) in seconds. If either start or stop is missing from the
#' records, the missing value is imputed with a 3 second adjustment by default.
#'
#' @return data frame
#' @export
#'
#' @import dplyr
#' @importFrom purrr map_dfr map_chr
#' @importFrom stringr str_pad
#' @importFrom readr read_csv cols
#' @importFrom glue glue
#'
#' @examples
#' # After running app and recording confessionals, run...
#' # Example from a saved timing file
#'
#' library(readr)
#'
#' path <- system.file(package = "survivoR", "extdata/US4412.csv")
#' df_us4412 <- read_csv(path)
#' get_confessional_timing(df_us4412, .vs = "US44", .episode = 12)
get_confessional_timing <- function(x, .vs, .episode, .mda = 3) {

  .vse <- paste0(.vs, str_pad(.episode, side = "left", width = 2, pad = 0))

  if(is.data.frame(x)) {

    df_time <- x %>%
        mutate(file_id = 1)

  } else {

    df_time <- map_dfr(x, ~{
      read_csv(.x, col_types = cols(), col_names = TRUE) %>%
        mutate(file_id = which(x == .x)) %>%
        set_names(c("global_id", "id", "castaway", "action", "time", "file_id"))
    })

  }

  df_time <- df_time %>%
    mutate(
      id0 = id,
      id = glue("ID{str_pad(file_id, side = 'left', width = 2, pad = 0)}{str_pad(id, side = 'left', width = 3, pad = 0)}")
      ) %>%
    select(-global_id) %>%
    ungroup() %>%
    group_by(action, id) %>%
    slice_min(time) %>%
    pivot_wider(names_from = action, values_from = time) %>%
    mutate(
      start = coalesce(start, stop - 3),
      stop = coalesce(stop, start + 3),
      duration = as.numeric(difftime(stop, start, units = "secs"))
    )

  # count confessionals
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
  if(!.vs %in% survivoR::season_summary$version_season) {
    in_progress_vs <- readLines("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/vs.txt")
    online_file <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}-boot-mapping.csv")
    df_boot_mapping <- read_csv(online_file, show_col_types = FALSE)
  } else {
    df_boot_mapping <- survivoR::boot_mapping
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
        summarise(confessional_time = round(sum(duration))) %>%
        mutate(
          version_season = .vs,
          episode = .episode
        ) %>%
        left_join(
          df_boot_mapping %>%
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
    ) %>%
    arrange(castaway)

}


#' Read episode transcripts
#'
#' Read the episode transcripts from Github. File is large and not explicitly part
#' of the package. Data is update by Matt Stiles.
#'
#' @return A data frame of episode transcripts
#' @export
#'
#' @importFrom readr read_csv
#'
#' @examples
#' # Run
#' # load_episode_transcripts()
#' # to load all transcripts
load_episode_transcripts <- function() {
  read_csv(
    "https://raw.githubusercontent.com/doehm/survivoR/refs/heads/master/dev/data/transcripts.csv",
    col_types = cols()
    )
}


#' Still alive
#'
#' Finds the set of players that are still alive at either the start or end of
#' an episode, or given a set number of boots.
#'
#' @param .vs Version season
#' @param .n_boots Number of boots
#' @param .ep Episode to evaluate who is alive.
#' @param .at Either 'start' or 'end'. If 'start' the flag will indicate who is
#' alive at the start of the episode. If 'end' it will indicate who is alive at
#' the end of the episode i.e. after tribal council.
#'
#' @return Data frame
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' # at the end of the episode
#' still_alive("US47", 12)
#'
#' # at the start of the episode
#' still_alive("US47", 12, .at = "start")
#'
still_alive <- function(.vs, .ep = NULL, .n_boots = NULL, .at = "end") {

  if(!is.null(.n_boots)) {
    out <- survivoR::boot_mapping |>
      filter(
        version_season %in% .vs,
        order == .n_boots,
        game_status %in% c("In the game", "Returned")
      ) |>
      group_by(castaway_id) |>
      slice_max(episode) |>
      ungroup()
  }

  if(!is.null(.ep)) {

    if(.at == "end") {
      .ep_x <- .ep
    } else {
      .ep_x <- .ep-1
    }

    df_cast <- survivoR::castaways |>
      filter_vs(.vs) |>
      filter(episode <= .ep_x) |>
      distinct(castaway_id)

    out <- survivoR::boot_mapping |>
      filter(
        version_season %in% .vs,
        episode == .ep,
        game_status %in% c("In the game", "Returned")
      ) |>
      group_by(castaway_id) |>
      slice_max(order) |>
      anti_join(
        df_cast,
        join_by(castaway_id)
      ) |>
      ungroup()
  }

  out

}
