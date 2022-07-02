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
#' @param versions Version
#'
#' @return List of combined data frames
#' @export
#'
#' @examples \dontrun{import_non_us_data()}
import_non_us_data <- function(versions = "AU") {

  df_list <- data(package = "survivoR")
  nm <- as.data.frame(df_list$results)
  nm$name <- stringr::str_extract(nm$Item, "[a-zA-Z_]+(?=[:space:])")
  nm$name <- dplyr::coalesce(nm$name, nm$Item)
  dat_names <- nm$name[nm$name != "hidden_idols"]
  pkgname <- paste0("survivoR::", dat_names)
  dat <- lapply(pkgname, function(.x) eval(parse(text = .x)))
  names(dat) <- dat_names
  dat$challenge_results <- tidyr::unnest(challenge_results, winners)

  # read in non us
  ext_files <- list.files(paste0(system.file(package = "survivoR"), "/extdata"), full.names = TRUE, recursive = TRUE)
  dat <- lapply(dat_names, function(x) {
    df1 <- dat[[x]]
    df2 <- readRDS(ext_files[grepl(x, ext_files)])
    df <- rbind(df1, df2)
  })
  names(dat) <- dat_names

  dat$castaway_details <- distinct(dat$advantage_details)
  dat$challenge_description <- distinct(dat$challenge_description)

  dat
}
