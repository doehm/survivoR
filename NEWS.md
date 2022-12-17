# survivoR 2.0.4

* Added complete US43 data
* Added sit_out to challenge results


# survivoR 2.0.1

New helper functions:

* `show_palette` for viewing the season palette generated from the logo
* `get_castaway_image` returns the URL of the castaway thumbnail for visualisation

Data:

* Updated US43 data
* Updated vote history data


# survivoR 2.0

Big update!

survivoR now includes:
* Non-US versions
  * Survivor Australia seasons 1-7
  * Survivor South Africa seasons 1-9
  * Survivor NZ season 1
  
New datasets:
* Completely refactored `challenge_results` dataset
  * Old dataset available with `challenge_results_dep` however it is encourage to use the new data set
* `survivor_auction` dataset
* `screen_time` dataset
  * Contains the estimate total seconds of screen time
  * Estimate from ML image detection model
  
Other updates:
* `short_name` on `castaway_details` is now `castaway` as per the other datasets
* `tribe` now exists on `vote_history`
* `boot_mapping` includes `game_status` to identify if they are in the game, on Redemption, etc
* Season 43 cast

Removed fields:
* `personality_type` from `castaways`

Notes:
* `advantage_movement` and `advantage_details` not complete for all Non-US versions


# survivoR 1.0.1

* Complete Season 42 data
* Updates to advantage datasets
* Updates to ggplot scales


# survivoR 1.0

* Season 42 episode 1 to 11 added
* 3 new data sets
  * `advantage_movement`
  * `advantage_details`
  * `boot_mapping`
* Updates to `challenge_results`
* New fields on `vote_history`
  * `tribe`
  * `vote_event`
  * `split_vote`
  * `tie`
* New fields on `viewers`
  * `imdb_rating`
* `version` and `version_season` now on all data sets in prep for non-US seasons
* Removed fields from `castaways`
  * `swapped_tribe`
  * `swapped_tribe_2`
  * `merged_tribe`
  * `total_vote_received`
  * `immunity_idols_won`


# survivoR 0.9.12

* Season 42 cast now added
* POC flag on `castaway_details`
* Updated Castaway IDs. Now in the format of USxxxx in preparation for non-US seasons. Original IDs can be recreated by extracting the digits

# survivoR 0.9.9

* New challenge data sets
  * challenge_results
  * challenge_description
* New castaways data set
  * castaway_details
  * Huge thank you to Carly Levitz for her contributions collating the gender and race data, and refinements across all data sets
* Season 41 palette and ggplot2 scale function

# survivoR 0.9.6

* Data corrections
  * season 41 tribe name
  * incorrect votes
  * duplicate records in `castaways` and `tribe_mapping`


# survivoR 0.9.5

* Added season 41 episodes 1 to 9
* Added new `confessionals` data set
* Bug fixes / data cleaning
  * The castaway names are consistent across data sets
  * Tribe mapping is updated filling in missing tribe status and Bobby Jon
  * Incorrect records from vote history removed.
  

# survivoR 0.9.4

* Added castaway ID to all data frames. A numeric key to link castaways across seasons and manage name changes
  * Boston Rob is now Boston Rob
  * Thank you to Holt Skinner for creating the ID and updating some of the castaway names
* Added new `challenge_name` field on the challenges data frame. Currently only has the Survivor Auction listed. Will be completed with all challenge names in the next release.
* Fixed more special character bugs in castaway names and episode titles


# survivoR 0.9.3

* Removed special characters from Kaoh Rong
* Fixed case on 'Black rock' on vote history
* Converted immunity and rewards tables in a challenges table. `immunity` and `rewards` will be deprecated at some point
* Added `hidden_idols`. A dataset on the hidden immunity idols found and played
