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


#' Reward challenges
#'
#' A dataset containing details on the reward challenges for each season
#'
#' @format Nested tidy data frame:
#' \describe{
#'   \item{season_name}{The season_name}
#'   \item{season}{The season number}
#'   \item{episode}{Episode number of when the reward challenge was played}
#'   \item{title}{Episode title}
#'   \item{Reward}{Winners of the reward challenge}
#' }
#' @details This is a nested data frame since more than one person can win the reward
#' @source \url{tba}
"rewards"

#' Immunity challenges
#'
#' A dataset containing details on the immunity challenges for each season
#'
#' @format Data frame:
#' \describe{
#'   \item{season_name}{The season_name}
#'   \item{season}{The season number}
#'   \item{episode}{Episode number of the reward challenge}
#'   \item{title}{Episode title}
#'   \item{immunity}{Winners of the immunity challenge}
#' }
#' @details Contains details on tribal immunity and individual immunity. Not hidden immunity however.
#' @source \url{tba}
"immunity"

#' Jury votes
#'
#' A dataset containing details on the final jury votes to determine the winner for each season
#'
#' @format Data frame:
#' \describe{
#'   \item{season_name}{The season_name}
#'   \item{season}{The season number}
#'   \item{castaway}{Name of the castaway}
#'   \item{finalist}{The finalists for which a vote can be placed}
#'   \item{vote}{Vote}
#' }
#' @source \url{tba}
#' @examples
#' jury_votes %>%
#'   filter(season == 40) %>%
#'   group_by(finalist) %>%
#'   summarise(votes = sum(vote))
"jury_votes"

#' Vote history
#'
#' A dataset containing details on the vote history for each season
#'
#' @format Data frame:
#' \describe{
#'   \item{season_name}{The season_name}
#'   \item{season}{The season number}
#'   \item{episode}{Episode number of the reward challenge}
#'   \item{title}{Episode title}
#'   \item{immunity}{Winners of the immunity challenge}
#' }
#' @source \url{tba}
"vote_history"
