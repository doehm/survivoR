#' Hidden immunity idols
#'
#' A dataset containing the complete history of hidden immunity idols
#'
#' @format A dataset containing the details of who found a hidden immunity idol,
#' when and when or if they played it:
#' \describe{
#'   \item{season}{The season the idol was found}
#'   \item{castaway}{Name of the castaway in possession of the idol. May not be the person who found it}
#'   \item{idol_number}{}
#'   \item{idols_held}{}
#' }
#' @source \url{tba}
"hidden_idols"


#' Castaways
#'
#' A dataset containing details on the castaways for each season.
#'
#' @format Data frame:
#' \describe{
#'   \item{season}{The season the idol was found}
#'   \item{castaway}{Name of the castaway in possession of the idol. May not be the person who found it}
#'   \item{gender}{Gender of castaway}
#'   \item{finish_position}{Finishing position e.g. 1 is the winner}
#'   \item{days}{Number of days the castaway survived}
#'   \item{days_on_exile}{Number of days on Exile Island}
#' }
#' @source \url{tba}
"castaways"
