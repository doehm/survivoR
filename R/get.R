#' Get cast for a season
#'
#' For a given season (or seasons) the function will return a data frame of the cast.
#'
#' @param .vs Version season. Can be a vector of `version_season` values.
#'
#' @returns A data frame
#' @export
#'
#' @examples
#' library(survivoR
#'
#' get_cast("US47")
get_cast <- function(.vs) {

  survivoR::boot_mapping |>
    filter(version_season %in% .vs) |>
    filter(order == 0) |>
    select(version_season, castaway_id, castaway)

}
