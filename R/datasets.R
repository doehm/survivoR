#' Castaways
#'
#' A dataset containing details on the castaways for each season.
#'
#' @format Data frame:
#' \describe{
#'   \item{season}{Sesaon number}
#'   \item{season_name}{Season name}
#'   \item{castaway}{Name of the castaway}
#'   \item{nickname}{Gender of castaway}
#'   \item{gender}{Gender of castaway}
#'   \item{age}{Age of the castaway}
#'   \item{city}{City of residence during the season they played}
#'   \item{state}{State of residence during the season they played}
#'   \item{day}{Number of days the castaway survived. A missing value indicates they later returned to the game that season}
#'   \item{original_tribe}{Original tribe name}
#'   \item{swapped_tribe}{Swapped tribe name}
#'   \item{swapped_tribe2}{second swapped tribe in the event of a second tribe swap or other tribe restructure such as absorbed tribe, outcasts, etc}
#'   \item{merged_tribe}{Merged tribe name}
#'   \item{result}{Final result}
#'   \item{order}{Finishing position e.g. 1 is the winner}
#' }
#'
#' @import tidyr
#'
#' @source \url{tba}
#' @examples \dontrun{
#' castaways %>%
#'   filter(season == 40)
#' }
"castaways"


#' Reward challenges
#'
#' A dataset containing details on the reward challenges for each season
#'
#' @format Nested tidy data frame:
#' \describe{
#'   \item{season_name}{Season name}
#'   \item{season}{Sesaon number}
#'   \item{episode}{Episode number of when the reward challenge was played}
#'   \item{title}{Episode title}
#'   \item{Reward}{Winners of the reward challenge. Tidy data frame. The list of castaway include all those that participated in the reward rather than simply the castaway that won the challenge.}
#' }
#' @details This is a nested data frame since more than one person can win the reward
#' @source \url{tba}
#' @examples \dontrun{
#' rewards
#' rewards %>%
#'   unnest(c(reward))
#' }
"rewards"

#' Immunity challenges
#'
#' A dataset containing details on the immunity challenges for each season
#'
#' @format Data frame:
#' \describe{
#'   \item{season_name}{The season_name}
#'   \item{season}{The season number}
#'   \item{episode}{Episode number of the immunity challenge was played}
#'   \item{title}{Episode title}
#'   \item{immunity}{Winners of the immunity challenge}
#' }
#' @details Contains details on tribal immunity and individual immunity. Not hidden immunity however.
#' @source \url{tba}
#' @examples \dontrun{
#' immunity
#' immunity %>%
#'   unnest(c(immunity))
#' }
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
#' @examples \dontrun{
#' jury_votes %>%
#'   filter(season == 40) %>%
#'   group_by(finalist) %>%
#'   summarise(votes = sum(vote))
#'   }
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
#'   \item{day}{Number of days the castaway survived. A missing value indicates they later returned to the game that season}
#'   \item{castaway}{Name of the castaway}
#'   \item{tribe_status}{The status of the tribe e.g. original tribe, swapped tribe, merged tribe, etc. See details for more}
#'   \item{vote}{The castaway for which the vote was cast}
#'   \item{voted_out}{Who was voted out}
#'   \item{order}{Finishing position e.g. 1 is the winner}
#' }
#' @details This data frame contains a complete history of votes cast across all seasons of Survivor. While there are consistent
#' events across the seasons there are some unique events which such as the 'mutiny' in Survivor: Cook Islands (season 13)
#' or the 'Outcasts' in Survivor: Pearl Islands (season 7). For maintaining a standard, whenever there has been a change
#' in tribe for the castaways it has been recorded as \code{tribe_status == 'swapped'}. Subsequent changes are recorded with
#' a digit. This includes absorbed tribes e.g. Stephanie was 'absorbed' in Survivor: Palau (season 10) and when 3 tribes are
#' reduced to 2. These cases are still considered 'swapped' to indicate a change in tribe status.
#' @source \url{tba}
#' @examples \dontrun{
#' # The number of times Tony voted for each castaway in Survivor: Winners at War
#' vote_history %>%
#'   filter(
#'     season == 40,
#'     castaway == "Tony"
#'   ) %>%
#'   count(vote)
#' }
"vote_history"

#' Tribe colours
#'
#' A dataset containing the tribe colours for each season
#'
#' @format Data frame:
#' \describe{
#'   \item{season_name}{The season_name}
#'   \item{season}{The season number}
#'   \item{tribe_name}{Tribe name}
#'   \item{r}{Red}
#'   \item{g}{Green}
#'   \item{b}{Blue}
#'   \item{tribe_colour}{Colour of the tribe}
#' }
#' @source \url{https://survivor.fandom.com/wiki/Tribe}
#' @examples \dontrun{
#' df <- tribe_colours %>%
#'   group_by(season_name) %>%
#'   mutate(
#'     xmin = 1,
#'     xmax = 2,
#'     ymin = 1:n(),
#'     ymax = ymin + 1
#'   ) %>%
#'   ungroup() %>%
#'   mutate(
#'     season_name = fct_reorder(season_name, season),
#'     font_colour = ifelse(tribe_colour == "#000000", "white", "black")
#'   )
#' ggplot() +
#'   geom_rect(data = df,
#'     mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
#'     fill = df$tribe_colour) +
#'   geom_text(data = df,
#'     mapping = aes(x = xmin+0.5, y = ymin+0.5, label = tribe_name),
#'     colour = df$font_colour) +
#'   theme_void() +
#'   facet_wrap(~season_name, scales = "free_y")
#' }
"tribe_colours"


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
