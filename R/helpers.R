#' Cleans votes
#'
#' There are certain events in the game of survivor which mean someone may attend tribal council and
#' not get the change to vote for some reason or their vote is unique e.g. when rocks are drawn. You
#' may want to remove the votes that were not an actual vote for a person. \code{clean_votes} is a
#' convenience function to remove these records. Can be piped.
#'
#' @param df Data frame which must contain the \code{vote} data.
#'
#' @importFrom stringr str_detect
#' @importFrom dplyr filter_at
#'
#' @return Returns a tidy data frame
#' @export
#'
#' @examples
#' library(dplyr)
#' vh <- vote_history |>
#' filter(
#'   season == 40,
#'   episode == 10
#' ) |>
#' count(vote)
#' vh
#'
#' vh |>
#' clean_votes()
clean_votes <- function(df) {
  filter_at(df, vars("vote"), ~!str_detect(tolower(.x), "win|won|lose|immune|none|vote|black rock|white rock|purple rock|yellow rock|exiled|saved|kidnap|countback"))
}

#' [EXPERIMENTAL] Import all Non-US seasons of SurvivoR
#'
#' @return Loads all versions of survivor into the package
#' @export
#'
#' @examples \dontrun{import_non_us_data()}
import_non_us_data <- function() {

  pkg_loc <- system.file(package = "survivoR")
  data_files <- list.files(glue::glue("{pkg_loc}/extdata/All"))
  for(k in data_files) {
    file.copy(
      glue::glue("{pkg_loc}/extdata/All/{k}"),
      glue::glue("{pkg_loc}/data/{k}"),
      overwrite = TRUE
    )
  }

  cat("\nNon US data loaded\n")
  cat("1. Restart session\n")
  cat("2. Run library(survivoR)\n\n")

}

#' [EXPERIMENTAL] Remove Non-US seasons of SurvivoR
#'
#' @return Removes the Non US data from the data frames
#' @export
#'
#' @examples \dontrun{remove_non_us_data()}
remove_non_us_data <- function() {

  pkg_loc <- system.file(package = "survivoR")
  data_files <- list.files(glue::glue("{pkg_loc}/extdata/US"))
  for(k in data_files) {
    file.copy(
      glue::glue("{pkg_loc}/extdata/US/{k}"),
      glue::glue("{pkg_loc}/data/{k}"),
      overwrite = TRUE
    )
  }

}
