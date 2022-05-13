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
