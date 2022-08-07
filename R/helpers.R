#' [EXPERIMENTAL] Import all Non-US seasons of SurvivoR
#'
#' This will import all available Non-US versions into the package
#' data
#'
#' @return Loads all versions of survivor into the package
#' @export
#'
#' @details This copies over all available Non-US versions to the
#' package data. After running the function you will need to restart
#' your session.
#'
#' Please note this is still experimental however it makes the data
#' accessible and allows you to debug any errors that may be present
#' in the code after importing.
#'
#' Error will arise when joining or filtering on `season` alone since
#' there are now multiple season 1's in the data. This can be easily
#' corrected by adding `version` to the filter or join.
#'
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

  cat("\nNon US data removed\n")
  cat("1. Restart session\n")
  cat("2. Run library(survivoR)\n\n")

}

#' Checks which versions are available in the data
#'
#' By default on install only US versions are available however
#' using `import_non_us_data` it will import all other Non-US
#' versions available. Running this function will quickly tell
#' you which versions have been loaded.
#'
#' @return A message indicating which versions are loaded
#' @export
#'
#' @examples which_versions()
which_versions <- function() {
  cat("\nVersions available:\n")
  cat(paste0(unique(survivoR::season_summary$version), collapse = ", "), "\n")
}
