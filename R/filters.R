#' Filter Alive
#'
#' Filters a given dataset to those that are still alive in the game at the start
#' or end of a user specified episode.
#'
#' @param df Input data frame. Must have `version_season`
#' @param .ep Episode. This will filter the castaways that are still alive at either the start or end of the episode.
#' @param .at Either 'start' or 'end' to filter those who are still alive in the game.
#'
#' @return A data frame filtered to castaways who are alive.
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   filter_us(47) |>
#'   filter_alive(12) |>
#'   group_by(castaway) |>
#'   summarise(n = sum(confessional_count))
filter_alive <- function(df, .ep = NULL, .at = "end") {

  df |>
    add_alive(.ep, .at) |>
    filter(alive)

}

#' Filters to the final n players
#'
#' @param df Input data frame. Must have `version_season`
#' @param .final_n An integer to represent the final `n` e.g. the final 4.
#'
#' @return A data frame filtered to only the final `n`
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   filter_us(47) |>
#'   filter_final_n(6) |>
#'   group_by(castaway) |>
#'   summarise(n = sum(confessional_count))
#'
filter_final_n <- function(df, .final_n) {

  vs <- unique(df$version_season)

  df_final_n <- survivoR::boot_mapping |>
    filter(
      version_season %in% vs,
      final_n == .final_n
    ) |>
    distinct(version_season, castaway)

  df |>
    semi_join(df_final_n, by = c("version_season", "castaway"))

}

#' Filter version season
#'
#' Filters a data set to a specified version season or list of version seasons.
#'
#' @param df Data frame. Must have `version_season`
#' @param .vs Version season.
#'
#' @return Data frame filtered to the specified version seasons
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   filter_vs("US47")
#'
filter_vs <- function(df, .vs) {

  df |>
    filter(version_season %in% .vs)

}


#' Filter to US seasons
#'
#' Filter a data set to a specified set of US season or list of seasons. A
#' shorthand version of `filter_vs()` for the US seasons.
#'
#' @param df Data frame. Must include `version` and `season`.
#' @param .season Season or vector of seasons. If `NULL` if will filter to all US seasons.
#'
#' @return Data frame filtered to the specified US seasons
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   filter_us(47)
#'
filter_us <- function(df, .season = NULL) {

  if(is.null(.season)) .season <- 1:99

  df |>
    filter(
      version == "US",
      season %in% .season
    )

}


#' Filter to the new era seasons
#'
#' Filters a data set to all New Era seasons.
#'
#' @param df Data frame. Must include `version` and `season`.
#'
#' @export
#' @return A data frame filtered to the New Era seasons.
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   filter_new_era() |>
#'   distinct(version_season)
#'
filter_new_era <- function(df) {

  df |>
    filter_us() |>
    filter(season >= 41)

}


#' Filter to winners
#'
#' Filters a data set to the winners of a given season.
#'
#' @param df Data frame. Requires `version_season` and `castaway_id`.
#'
#' @export
#' @return A data frame filtered to the winners
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   filter_winner()
#'
filter_winner <- function(df) {

  df |>
    add_winner() |>
    filter(winner)

}


#' Filter to finalists
#'
#' Filters a data set to the finalists of a given season.
#'
#' @param df Data frame. Requires `version_season` and `castaway_id`.
#'
#' @export
#' @return A data frame filtered to the finalists
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   filter_finalist()
#'
filter_finalist <- function(df) {

  df |>
    add_finalist() |>
    filter(finalist)

}


#' Filter to jury
#'
#' Filters a data set to the jury members of a given season.
#'
#' @param df Data frame. Requires `version_season` and `castaway_id`.
#'
#' @export
#' @return A data frame filtered to the jury members
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   filter_jury()
#'
filter_jury <- function(df) {

  df |>
    add_jury() |>
    filter(jury)

}

