#' Season summary
#'
#' A dataset containing a summary of all 40 seasons of Survivor
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{Season name}
#'   \item{\code{season}}{Sesaon number}
#'   \item{\code{n_cast}}{Number of cast in the season}
#'   \item{\code{location}}{Location of the season}
#'   \item{\code{country}}{Country the season was held}
#'   \item{\code{tribe_setup}}{Initial setup of the tribe e.g. heroes vs Healers vs Hustlers}
#'   \item{\code{full_name}}{Full name of the winner}
#'   \item{\code{winner_id}}{ID for the winner of the season (primary key)}
#'   \item{\code{winner}}{Winner of the season}
#'   \item{\code{runner_ups}}{Runner ups for the season. Either one or two runner ups as a string}
#'   \item{\code{final_vote}}{Final vote allocation. See the \code{jury_votes} dataset for better aggregation of this data}
#'   \item{\code{timeslot}}{Timeslot of the show in the US}
#'   \item{\code{premiered}}{Date the first episode aired}
#'   \item{\code{ended}}{Date the season ended}
#'   \item{\code{filming_started}}{Date the filming of the season started}
#'   \item{\code{filming_ended}}{Date the filming ended (39 or 42 days after the start)}
#'   \item{\code{viewers_premiere}}{Number of viewers (millions) who tuned in for the premier}
#'   \item{\code{viewers_finale}}{Number of viewers (millions) who tuned in for the finale}
#'   \item{\code{viewers_reunion}}{Number of viewers (millions) who tuned in for the reunion}
#'   \item{\code{viewers_mean}}{Average number of viewers (millions) who tuned in over the season}
#'   \item{\code{rank}}{Season rank}
#' }
#'
#' @import tidyr
#'
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
"season_summary"

#' Castaways
#'
#' A dataset containing details on the results for every castaway and season
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season}}{Sesaon number}
#'   \item{\code{season_name}}{Season name}
#'   \item{\code{full_name}}{Full name of the castaway}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU (TBA).}
#'   \item{\code{castaway}}{Name of castaway. Generally this is the name they were most commonly referred to
#'   or nickname e.g. no one called Coach, Benjamin. He was simply Coach}
#'   \item{\code{age}}{Age of the castaway during the season they played}
#'   \item{\code{city}}{City of residence during the season they played}
#'   \item{\code{state}}{State of residence during the season they played}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{day}}{Number of days the castaway survived. A missing value indicates they later returned to the game that season}
#'   \item{\code{order}}{Boot order. Order in which castaway was voted out e.g. 5 is the 5th person voted of the island}
#'   \item{\code{result}}{Final result}
#'   \item{\code{result_number}}{Result number i.e. the final place. NA for castaways that were voted out but later returned e.g. Redemption Island}
#'   \item{\code{jury_status}}{Jury status}
#'   \item{\code{original_tribe}}{Original tribe name}
#' }
#'
#' @details If the original \code{castaway_id} is desired simply extract the digits from the ID e.g.
#' \code{castaway_id = as.numeric(str_extract(castaway_id, '[:digit:]+'))} in a mutate step.
#'
#' @import tidyr
#'
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
#' @examples
#' library(dplyr)
#' castaways %>%
#'   filter(season == 40)
"castaways"

#' Castaway details
#'
#' A dataset containing details on the castaways for each season
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU (TBA).}
#'   \item{\code{full_name}}{Full name of the castaway}
#'   \item{\code{full_name_detailed}}{A detailed version of full_name for plotting e.g. 'Boston' Rob Mariano}
#'   \item{\code{castaway}}{Short name of the castaway. Name typically used during the season. Sometimes there are multiple
#'   people with the same name e.g. Rob C and Rob M in Survivor All-Stars. This field takes the most verbose name used}
#'   \item{\code{date_of_birth}}{Date of birth}
#'   \item{\code{date_of_death}}{Date of death}
#'   \item{\code{gender}}{Gender of castaway}
#'   \item{\code{race}}{Race (if known)}
#'   \item{\code{ethnicity}}{Ethnicity (if known)}
#'   \item{\code{poc}}{POC indicator if known and can point to a source, else marked as white. It is understood this is a contentious issue and ultimately up to the individual as to how they wish to be identified. Please log corrections on the Github page.}
#'   \item{\code{personality_type}}{The Myer-Briggs personality type of the castaway}
#'   \item{\code{lgbt}}{LGBTQIA+ status as listed on the survivor wiki.}
#'   \item{\code{occupation}}{Occupation}
#'   \item{\code{three_words}}{Answer to the question "three words to describe you?"}
#'   \item{\code{hobbies}}{Answer to the question "what are you favourite hobbies?"}
#'   \item{\code{pet_peeves}}{Answer to the question "what are your pet peeves?"}
#' }
#'
#' @details Race and ethnicity data is included if known and can point to a source, rather than making an assumption
#' about an individual.
#'
#' @import tidyr
#'
#' @source
#' \url{https://survivor.fandom.com/wiki/Main_Page},
#' \url{https://www.personality-database.com/}
#' @examples
#' library(dplyr)
#' castaway_details |>
#'   count(gender)
"castaway_details"

#' Jury votes
#'
#' A dataset containing details on the final jury votes to determine the winner for each season
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{castaway}}{Name of the castaway}
#'   \item{\code{finalist}}{The finalists for which a vote can be placed}
#'   \item{\code{vote}}{Vote. 0-1 variable for easy summation}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU.}
#'   \item{\code{finalist_id}}{The ID of the finalist for which a vote can be placed. Consistent with castaway ID}
#' }
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
#'
#' @examples
#' library(dplyr)
#' jury_votes %>%
#'   filter(season == 40) %>%
#'   group_by(finalist) %>%
#'   summarise(votes = sum(vote))
"jury_votes"

#' Vote history
#'
#' A dataset containing details on the vote history for each season
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{day}}{Day the tribal council took place}
#'   \item{\code{tribe_status}}{The status of the tribe e.g. original, swapped, merged, etc. See details for more}
#'   \item{\code{tribe}}{Tribe name}
#'   \item{\code{castaway}}{Name of the castaway}
#'   \item{\code{immunity}}{Type of immunity held by the castaway at the time of the vote e.g. individual,
#'   hidden (see details for hidden immunity data)}
#'   \item{\code{vote}}{The castaway for which the vote was cast}
#'   \item{\code{vote_event}}{Extra details on the vote e.g. Won or lost the fire challenge, played an extra vote, etc}
#'   \item{\code{vote_event_outcome}}{The outcome of the vote event}
#'   \item{\code{split_vote}}{If there was a decision to split the vote this records who the vote was split with.
#'   Helps to identify successful boots}
#'   \item{\code{nullified}}{Was the vote nullified by a hidden immunity idol? Logical}
#'   \item{\code{tie}}{If the set of votes resulted in a tie. Logical}
#'   \item{\code{voted_out}}{The castaway who was voted out}
#'   \item{\code{order}}{Boot order. Order in which castaway was voted out e.g. 5 is the 5th person voted of the island}
#'   \item{\code{vote_order}}{In the case of ties this indicates the order the votes took place}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU.}
#'   \item{\code{vote_id}}{ID of the castaway voted for}
#'   \item{\code{voted_out_id}}{ID of the castaway voted_out}
#' }
#' @details This data frame contains a complete history of votes cast across all seasons of Survivor. While there are consistent
#' events across the seasons there are some unique events such as the 'mutiny' in Survivor: Cook Islands (season 13)
#' or the 'Outcasts' in Survivor: Pearl Islands (season 7). For maintaining a standard, whenever there has been a change
#' in tribe for the castaways it has been recorded as \code{swapped}. \code{swapped} is used as the
#' term since 'the tribe swap' is a typical recurring milestone in each season of Survivor. Subsequent changes are recorded with
#' a trailing digit e.g. \code{swapped2}. This includes absorbed tribes e.g. Stephanie was 'absorbed'
#' in Survivor: Palau (season 10) and when 3 tribes are
#' reduced to 2. These cases are still considered 'swapped' to indicate a change in tribe status.
#'
#' Some events result in a castaway attending tribal but not voting. These are recorded as
#' \describe{
#'   \item{\code{Win}}{The castaway won the fire challenge}
#'   \item{\code{Lose}}{The castaway lost the fire challenge}
#'   \item{\code{None}}{The castaway did not cast a vote. This may be due to a vote steal or some other means}
#'   \item{\code{Immune}}{The castaway did not vote but were immune from the vote}
#' }
#'
#' Where a castaway has \code{immunity == 'hidden'} this means that player is protected by a hidden immunity idol. It may not
#' necessarily mean they played the idol, the idol may have been played for them. While the nullified votes data is complete
#' the \code{immunity} data does not include those who had immunity but did not receive a vote. This is a TODO.
#'
#' In the case where the 'steal a vote' advantage was played, there is a second row for the castaway that stole the vote.
#' The castaway who had their vote stolen are is recorded as \code{None}.
#'
#' Many castaways have been medically evacuated, quit or left the game for some other reason. In these cases where no votes
#' were cast there is a skip in the \code{order} variable. Since no votes were cast there is nothing to record on this
#' data frame. The correct order in which castaways departed the island is recorded on \code{castaways}.
#'
#' In the case of a tie, \code{voted_out} is recorded as \code{tie} to indicate no one was voted off the island in that
#' instance. The re-vote is recorded with \code{vote_order = 2} to indicate this is the second round of voting. In
#' the case of a second tie \code{voted_out} is recorded as \code{tie2}. The third step is either a draw of rocks,
#' fire challenge or countback (in the early days of survivor). In these cases \code{vote} is recorded as the colour of the
#' rock drawn, result of the fire challenge or 'countback'.
#'
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
#' @examples
#' # The number of times Tony voted for each castaway in Survivor: Winners at War
#' library(dplyr)
#' vote_history %>%
#'   filter(
#'     season == 40,
#'     castaway == "Tony"
#'   ) %>%
#'   count(vote)
"vote_history"

#' Tribe colours
#'
#' A dataset containing the tribe colours for each season
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{tribe}}{Tribe name}
#'   \item{\code{tribe_colour}}{Colour of the tribe}
#'   \item{\code{tribe_status}}{Tribe status e.g. original, swapped or merged. In the instance where a tribe is formed at the swap by
#'   splitting 2 tribes into 3, the 3rd tribe will be labelled 'swapped'}
#' }
#' @source \url{https://survivor.fandom.com/wiki/Tribe}
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' library(forcats)
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
#'     mapping = aes(x = xmin+0.5, y = ymin+0.5, label = tribe),
#'     colour = df$font_colour) +
#'   theme_void() +
#'   facet_wrap(~season_name, scales = "free_y")
"tribe_colours"

#' Viewers
#'
#' A dataset containing the viewer history for each season and episode
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{Season number}
#'   \item{\code{episode_number_overall}}{The cumulative episode number}
#'   \item{\code{episode}}{Episode number for the season}
#'   \item{\code{episode_title}}{Episode title}
#'   \item{\code{episode_label}}{A standardised episode label}
#'   \item{\code{episode_date}}{Date the episode aired}
#'   \item{\code{episode_length}}{Episode length in minutes}
#'   \item{\code{viewers}}{Number of viewers (millions) who tuned in}
#'   \item{\code{imdb_rating}}{IMDb rating for the episode on a scale of 0-10}
#'   \item{\code{n_ratings}}{The number of ratings submitted to IMDb}
#' }
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
"viewers"

#' Episodes
#'
#' A dataset containing details for each episode
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{Season number}
#'   \item{\code{episode_number_overall}}{The cumulative episode number}
#'   \item{\code{episode}}{Episode number for the season}
#'   \item{\code{episode_title}}{Episode title}
#'   \item{\code{episode_label}}{A standardised episode label}
#'   \item{\code{episode_date}}{Date the episode aired}
#'   \item{\code{episode_length}}{Episode length in minutes}
#'   \item{\code{viewers}}{Number of viewers (millions) who tuned in}
#'   \item{\code{imdb_rating}}{IMDb rating for the episode on a scale of 0-10}
#'   \item{\code{n_ratings}}{The number of ratings submitted to IMDb}
#' }
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
"episodes"

#' Season palettes
#'
#' A dataset containing palettes generated from the season logos
#'
#' @format This nested data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{palette}}{The season palette}
#' }
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
"season_palettes"

#' Challenge Results
#'
#' A dataset detailing the challenges played including reward and immunity challenges.
#'
#' @format This data frame contains the following columns
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{n_boots}}{The number of boots that there have been in the game e.g. if `n_boots == 2` there have been 2
#'   boots in the game so far and there are N-2 castaways left in the game}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU (TBA).}
#'   \item{\code{castaway}}{Name of castaway. Generally this is the name they were most commonly referred to
#'   or nickname e.g. no one called Coach, Benjamin. He was simply Coach}
#'   \item{\code{challenge_name}}{The name of the challenge. Challenges can go by different names but where possible
#'   recurring challenges are kept consistent. While there are tweaks to the challenges where the main components of
#'   the challenge consistent they share the same name}
#'   \item{\code{outcome_type}}{Whether the challenge is individual or tribal. Some individual reward challenges may involve multiple castawats as the winner gets to choose who they bring along}
#'   \item{\code{tribe}}{Current tribe the castaway is on}
#'   \item{\code{tribe_status}}{The status of the tribe e.g. original, swapped, merged, etc. See details for more}
#'   \item{\code{challenge_type}}{The challenge type e.g. immunity, reward, etc}
#'   \item{\code{challenge_id}}{Primary key to the \code{challenge_description} data set which contains features of the challenge}
#'   \item{\code{result}}{Result of challenge}
#'   \item{\code{chosen_for_reward}}{If after the reward challenge the castaway was chosen to participate in the reward}
#'   \item{\code{sit_out}}{\code{TRUE} if they sat out of the challenge or \code{FALSE} if they participate}
#' }
#'
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
#' @examples
#' library(dplyr)
#' library(tidyr)
#' challenge_results %>%
#'   filter(season == 40)
"challenge_results"

#' Challenge Description
#'
#' A dataset detailing the challenges played and the elements they include over all seasons of Survivor
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{challenge_id}}{Primary key}
#'   \item{\code{challenge_name}}{The name of the challenge. Challenges can go by different names but where possible
#'   recurring challenges are kept consistent. While there are tweaks to the challenges where the main components of
#'   the challenge consistent they share the same name}
#'   \item{\code{puzzle}}{If the challenge contains a puzzle element}
#'   \item{\code{race}}{If the challenge is a race between tribes, teams or individuals}
#'   \item{\code{precision}}{If the challenge contains a precision element e.g. shooting an arrow, hitting a target, etc}
#'   \item{\code{endurance}}{If the challenge is an endurance event e.g. last tribe, team, individual standing}
#'   \item{\code{strength}}{If the challenge has a strength based}
#'   \item{\code{turn_based}}{If the challenge is turn bases i.e. conducted in rounds}
#'   \item{\code{balance}}{If the challenge contains a balancing element. My refer to the player balancing on something or
#'   the player balancing an object on something e.g. The Ball Drop}
#'   \item{\code{food}}{If the challenge contains a food element e.g. the food challenge, biting off chunks of meat}
#'   \item{\code{knowledge}}{If the challenge contains a knowledge component e.g. Q and A about the location}
#'   \item{\code{memory}}{If the challenge contains a memory element e.g. memorising a sequence of items}
#'   \item{\code{fire}}{If the challenge contains an element of fire making / maintaining}
#'   \item{\code{water}}{If the challenge is held, in part, in the water}
#' }
#'
#' @details The features of each challenge have been determined largely through string searches of key words or phraces in the
#' challenge description. It may not capture the full essence of the challenge but on the whole will provide a good basis for
#' analysis.
#'
#' Please log any suggested corrections at \url{https://github.com/doehm/survivoR}
#'
#' For updated data please see the git version.
#'
#' @source \url{https://survivor.fandom.com/wiki/Category:Challenges}
#' @examples
#' library(dplyr)
#' library(tidyr)
#' challenge_description
"challenge_description"

#' Tribe mapping
#'
#' A mapping for castaways to tribes for each day (day being the day of the tribal council)
#' This is useful for observing who is on what tribe throughout the game.
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{day}}{The day of the tribal council}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU.}
#'   \item{\code{castaway}}{Name of the castaway}
#'   \item{\code{tribe}}{Name of the tribe the castaway was on}
#'   \item{\code{tribe_status}}{The status of the tribe e.g. original, swapped, merged, etc. See details for more}
#' }
#'
#' @details Each season by episode and day holds a complete list of castaways still in the game and
#' which tribe they are on. Moving through each day you can observe the changes in
#' the tribe. For example the first day has all castaways mapped to their
#' original tribe. The next day has the same minus the castaway just voted out. This
#' is useful for observing the changes in tribe make either due to castaways being voted
#' off the island, tribe swaps, who is on Redemption Island and Edge of Extinction.
#'
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
"tribe_mapping"

#' Boot mapping
#'
#' A mapping table for easily filtering to the set of castaways that are still in the game
#' after a specified number of boots.
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{order}}{The number of boots that there have been in the game e.g. if `order == 2` there have been 2
#'   boots in the game so far and there are N-2 castaways left in the game}
#'   \item{\code{final_n}}{The final number of castaways e.g. you can filter to the final 4 by `filter(boot_mapping, final_n == 4)`}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU.}
#'   \item{\code{castaway}}{Name of the castaway}
#'   \item{\code{tribe}}{Name of the tribe the castaway was on}
#'   \item{\code{tribe_status}}{The status of the tribe e.g. original, swapped, merged, etc. See details for more}
#'   \item{\code{game_status}}{Logical flag to identify if the castaway is currently in the game. If `FALSE` the castaway
#'   is on Redemption Island or Edge of Extinction.}
#' }
#'
#' @source \url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)}
"boot_mapping"

#' Confessionals
#'
#' A dataset containing the count of confessionals per castaway per episode. A confessional is when
#' the castaway is speaking directly to the camera about their game.
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{castaway}}{Name of the castaway}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU.}
#'   \item{\code{confessional_count}}{The count of confessionals for the castaway during the episode}
#'   \item{\code{confessional_time}}{The total time for all confessionals for the episode for each castaway}
#'   \item{\code{index_count}}{The index based on the confessional counts. See details.}
#'   \item{\code{index_time}}{The index based on the confessional time. See details.}
#' }
#'
#' @details Confessional data has been counted by contributors of the survivoR R package and consolidated
#' with external sources. The aim is to establish consistency in confessional counts in the absence of official
#' sources. Given the subjective nature of the counts and the potential for clerical error no single source is
#' more valid than another. Therefore, it is reasonable to average across all sources.
#'
#' In the case of double or extended episodes, if the episode only has one title it is considered a single episode. This
#' means the average number of confessionals per person is likely to be higher for this episode given it's length. If
#' there are two episode titles the confessionals are counted for the appropriate episode. This is to ensure consistency
#' across all other datasets.
#'
#' In the case of recap episodes, this episode is left blank.
#'
#' The indexes are a measure of how many more confessional counts or time the castaway has received given the point in the game.
#' For example a `index_count` of 1 implies the castaway has received the expected number of confessionals given equal share within tribe.
#' An index of 1.5 implies have have received 50% more. The measure is standardised within tribe since the tribe that goes to tribal
#' typically receives more confessionals for the episode. Makes sense. `index_time` is the same but using time instead of counts.
#'
#' If you also count confessionals, please get in touch and I'll add them into the package.
"confessionals"

#' Advantage Movement
#'
#' A dataset containing the movement details of each advantage or hidden immunity idol. Each row
#' is considered an event e.g. the idol was found, played, etc. If the advantage changed hands
#' it records who received it. The logical flow is identified by the `sequence_id`.
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{castaway}}{Name of the castaway involved in the event e.g. found, played, received, etc.}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU.}
#'   \item{\code{advantage_id}}{The ID / primary key of the advantage}
#'   \item{\code{sequence_id}}{The sequnnce of events. For example `sequence_id == 1` usually means the advantage was found. Each subsequent event follows the `sequence_id`}
#'   \item{\code{day}}{The day the event occured}
#'   \item{\code{episode}}{The episode the event occured}
#'   \item{\code{event}}{The event e.g. the advantage was found, played, received, etc}
#'   \item{\code{played_for}}{If the advantage or idol was played this records who it was played for}
#'   \item{\code{played_for_id}}{the ID for who the advantage or idol was played for}
#'   \item{\code{success}}{If the play was succesful or not. Only relavent for advantages since playing a hidden immunity idol is always sucessful in terms of saving who it was played for.}
#'   \item{\code{votes_nullified}}{In the case of hidden immunity idols this is the count of how many votes were nullified when played}
#' }
"advantage_movement"

#' Advantage Details
#'
#' A dataset containing the details and characteristics of each idol and advantage. This maps to `advantage_movement`
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{advantage_id}}{The ID / primary key of the advantage}
#'   \item{\code{advantage_type}}{Advantage type e.g. hidden immunity idol, extra vote, steal a vote, etc}
#'   \item{\code{clue_details}}{Details if a clue existed for the advantage and if so where was the clue found}
#'   \item{\code{location_found}}{The location the idol or advantage was found}
#'   \item{\code{conditions}}{Extra details about the unique conditions of the idol or advantage}
#' }
#'
#' @details There are split idols which need to be combined to be played. In these case the first one found is
#' given an ID. The second or subsequent parts are given the same ID with a trailing letter. For example in season 40
#' Denise found an idol that was split (USHI4002). Later she found the other half (USHI4002b). When played the second half is
#' considered to have 'absorbed' into the first idol. The first idol found is always considered the primary idol.
"advantage_details"

#' Screen Time
#'
#' A dataset summarising the screen time of contestants on the TV show Survivor.
#' Currently only contains Season 1-4 and 42.
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Also includes
#'   two special IDs of host (i.e. Jeff Probst) or unknown (the image detection
#'   couldn't identify the face with sufficient accuracy)}
#'   \item{\code{screen_time}}{Estimated screen time for the individual in seconds.}
#' }
#'
#' @details Individuals' screen time is calculated, at a high-level, via the following process:
#'
#' \enumerate{
#'    \item Frames are sampled from episodes on a 1 second time interval
#'    \item MTCNN detects the human faces within each frame
#'    \item VGGFace2 converts each detected face into a 512d vector space
#'    \item A training set of labelled images (1 for each contestant + 3 for
#'    Jeff Probst) is processed in the same way to determine where they sit in
#'    the vector space.
#'    TODO: This could be made more accurate by increasing the number of training
#'    images per contestant.
#'    \item The Euclidean distance is calculated for the faces detected in the frame
#'    to each of the contestants in the season (+Jeff). If the minimum distance is
#'    greater than 1.2 the face is labelled as "unknown".
#'    TODO: Review how robust this distance cutoff truly is - currently based on
#'    manual review of Season 42.
#'    \item A multi-class SVM is trained on the training set to label faces. For
#'    any face not identified as "unknown", the vector embedding is run into this
#'    model and a label is generated.
#'    \item All labelled faces are aggregated together, with an assumption of 1
#'    full second of screen time each time a face is seen.
#' }
"screen_time"

#' Survivor Auction
#'
#' A dataset showing who attended the Survivor Auction during the seasons they were held
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{version}}{Country code for the version of the show}
#'   \item{\code{version_season}}{Version season key}
#'   \item{\code{season_name}}{The season name}
#'   \item{\code{season}}{The season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{n_boots}}{The number of boots so far in the game}
#'   \item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU (TBA).}
#'   \item{\code{castaway}}{Name of castaway. Generally this is the name they were most commonly referred to
#'   or nickname e.g. no one called Coach, Benjamin. He was simply Coach}
#'   \item{\code{tribe_status}}{The status of the tribe e.g. original, swapped, merged, etc. See details for more}
#'   \item{\code{tribe}}{Tribe name}
#' }
"survivor_auction"
