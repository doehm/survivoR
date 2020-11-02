#' Season summary
#'
#' A dataset containing a summary of all 40 seasons of survivor
#'
#' @format Data frame:
#' \describe{
#'   \item{season_name}{Season name}
#'   \item{season}{Sesaon number}
#'   \item{location}{Location of the season}
#'   \item{country}{Country the season was held}
#'   \item{tribe_setup}{Initial setup of the tribe e.g. heroes vs Healers vs Hustlers}
#'   \item{winner}{Winner of the season}
#'   \item{nickname}{Nickname of the winner of the season e.g. J.T.}
#'   \item{runner_ups}{runner ups for the season. Nested data from given there may be 2 runner ups and this preserves the grain of the data being a season}
#'   \item{final_vote}{Final vote allocation. See the \code{jury_votes} dataset for better aggregation of this data}
#'   \item{timeslot}{Timeslot of the show in the US}
#'   \item{premiered}{Date the first episode aired}
#'   \item{ended}{Date the season ended}
#'   \item{viewers_premier}{Number of viewers (millions) who tuned in for the premier}
#'   \item{viewers_finale}{Number of viewers (millions) who tuned in for the finale}
#'   \item{viewers_reunion}{Number of viewers (millions) who tuned in for the reunion}
#'   \item{viewers_mean}{Average number of viewers (millions) who tuned in over the season}
#'   \item{rank}{Season rank}
#' }
#'
#' @import tidyr
#'
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
#' @examples \dontrun{
#' View(season_summary)
#' }
"season_summary"


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
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
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
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
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
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
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
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
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
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
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
#'   \item{tribe}{Tribe name}
#'   \item{r}{Red}
#'   \item{g}{Green}
#'   \item{b}{Blue}
#'   \item{tribe_colour}{Colour of the tribe}
#'   \item{tribe_status}{Tribe status e.g. original, swapped or merged. In the instance where a tribe is formed at the swap by
#'   splitting 2 tribes into 3, the 3rd tribe will be labelled 'swapped'}
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
#'   geom_rect(data = df, mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), fill = df$tribe_colour) +
#'   geom_text(data = df, mapping = aes(x = xmin+0.5, y = ymin+0.5, label = tribe), colour = df$font_colour) +
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
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
"hidden_idols"

#' Viewers
#'
#' A dataset containing the viewer history for each season
#'
#' @format data frame
#' \describe{
#'   \item{season_name}{The season_name}
#'   \item{season}{The season the idol was found}
#'   \item{episode_number_overall}{The cumulative episode number}
#'   \item{episode}{Episode number for the season}
#'   \item{title}{Episode title}
#'   \item{episode_date}{Date the episode aired}
#'   \item{viewers}{Number of viewers (millions) who tuned in.}
#'   \item{rating_18_49}{TV rating for the 18-49 aged group}
#'   \item{share_18_49}{TV share for the 18_49 aged group}
#' }
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
"viewers"
