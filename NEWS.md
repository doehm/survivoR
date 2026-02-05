# survivoR 2.3.10

* fx for dplyr 'id' update


# survivoR 2.3.9

* Adding complete US49 data


# survivoR 2.3.8

* Updating functions before stringr release
* A few data corrections


# survivoR 2.3.7

* Adding complete AU11 data


# survivoR 2.3.6

* Adding complete US48 data
* Huge update to `castaway_scores`
* New `boot_order` data set
* Update to `castaways` such that it no longer includes people booted more than once
* `season_name` has been deprecated from all tables other than `season_summary`
* Season 50 cast added


# survivoR 2.3.5

* Adding complete US47 data
* Adding new `castaway_scores` dataset
* Adding new `add_*` functions:
	* add_alive(): Adds a logical flag if the castaway is alive at the start or end of an episode 
	* add_bipoc(): Adds a BIPOC to the data frame. If any African American, Asian American, Latin American, or Native American is TRUE then BIPOC is TRUE. 
	* add_castaway(): Adds castaway to a data frame. Input data frame must have castaway_id. 
	* add_demogs(): Add demographics that includes age, gender, race/ethnicity, and lgbtqia+ status to a data frame with castaway_id. 
	* add_finalist(): Adds a winner flag to the data set. 
	* add_full_name(): Adds full name to the data frame. Useful for plotting and making tables. 
	* add_gender(): Adds gender to a data frame 
	* add_jury(): Adds a jury member flag to the data set. 
	* add_lgbt(): Adds the LGBTQIA+ flag to the data frame. 
	* add_result(): Adds the result and place to the data frame. 
	* add_tribe(): Adds tribe to a data frame for a specified stage of the game e.g. original, swapped, swapped_2, etc. 
	* add_tribe_colour(): Add tribe colour to the data frame. Useful for preparing the data for plotting with ggplot2. 
	* add_winner(): Adds a winner flag to the data set.
* Adding new `filter_*` functions:
	* filter_alive(): Filters a given dataset to those that are still alive in the game at the start or end of a user specified episode. 
	* filter_final_n(): Filters to the final `n` players e.g. the final 5.
	* filter_finalist(): Filters a data set to the finalists of a given season. 
	* filter_jury(): Filters a data set to the jury members of a given season. 
	* filter_new_era(): Filters a data set to all New Era seasons. 
	* filter_us(): Filter a data set to a specified set of US season or list of seasons. A shorthand version of filter_vs() for the US seasons. 
	* filter_vs(): Filters a data set to a specified version season or list of version seasons. 
	* filter_winner(): Filters a data set to the winners of a given season. 


# survivoR 2.3.4

* Adding a new key `sog_id` (stage of game ID) to `boot_mapping`, `challenge_results`, and `vote_history`. This makes it easier to join those tables and reference a particular stage of the game. The stage of the game is determined by a change in players/tribe setup e.g. whenever someone is voted out, medically evacuated, switches tribes, or simply starting a new episode the `sog_id` increase by 1. This is now available but still being developed and running a bunch of tests, so please let me know if there are inconsistencies.
* `n_boots` is now on `boot_mapping`.
* Minor updates to data across all data sets


# survivoR 2.3.3

* Adding complete seasons
    * US46
* New data set added
    * episode_summary - the summary of the episode from Wikipedia
    * challenge_summary - a summarised version of challenge_results for easy analysis
* New fields added
    * team on challenge_results - identifying the team which the castaways were on during the challenge


# survivoR 2.3.2

* Adding complete seasons
    * AU09


# survivoR 2.3.1

* Expanded challenge_descriptions
* Minor fixes


# survivoR 2.3.0

* Adding complete seasons
    * US45
    * UK03
* New data set auction_details
* New features on survivor_auction
* Refreshed challenge_description. Includes:
    * Name
    * Recurring name
    * Description
    * Reward description
    * Challenge characteristics
    * Refreshed challenge_id
* Refreshed challenge_results. Includes:
    * New challenge_id to link with challenge_description
    * New challenge_types e.g. Team / Individual when there are multiple winning conditions
    * New feature result_notes contain info on result winning conditions
* episode_label on episodes e.g. finale, reunion, etc
* Logicals on castaways to filter for
    * finalists
    * winner 
    * jury

# survivoR 2.1.0

* Version increment
* Adding complete US44, UK01 and NZ02 data
* New confessional timing shiny app.
  * Run with launch_confessional_app()

# survivoR 2.0.8

* Adding complete AU08 data
* New features
    * `final_n` on `boot_mapping`
    * `n_cast` on `season_summary`
    * `index_count` and `index_time` on `confessionals`
* New `challenge_id` on `challenge_results`


# survivoR 2.0.7

* New feature vote_event_outcome on vote_history
* Adding AU08 cast data


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
