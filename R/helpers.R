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
#' vh <- vote_history %>%
#' filter(
#'   season == 40,
#'   episode == 10
#' ) %>%
#' count(vote)
#' vh
#'
#' vh %>%
#' clean_votes()
clean_votes <- function(df) {
  df %>%
    filter_at(vars("vote"), ~!str_detect(tolower(.x), "win|won|lose|immune|none|vote|black rock|white rock|purple rock|yellow rock|exiled|saved|kidnap|countback"))
}


