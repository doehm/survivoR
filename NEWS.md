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
