Version increment
survivoR now includes:
* Non-US versions
  * Survivor Australia seasons 1-7
  * Survivor South Africa seasons 1-9
  * Survivor NZ season 1
  
New datasets:
* Completely refactored `challenge_results` dataset
* `survivor_auction` dataset
* `screen_time` dataset
  
Other updates:
* `short_name` on `castaway_details` is now `castaway` as per the other datasets
* `tribe` now exists on `vote_history`
* `boot_mapping` includes `game_status` to identify if they are in the game, on Redemption, etc
* Season 43 cast

Removed fields:
* `personality_type` from `castaways`
