library(dplyr)
library(stringr)


# VOTE HISTORY ------------------------------------------------------------

test_that("📜 No one voted for themselves", {
  x <- vote_history |>
    filter(castaway == vote)

  expect_equal(nrow(x), 0)
})


test_that("📜 Correct split votes", {
  x <- vote_history |>
    filter(!is.na(split_vote), !str_detect(split_vote, vote)) |>
    nrow()

  expect_equal(x, 0)
})

test_that("📜 No votes for people who have immunity", {
  immune <- vote_history |>
    filter(
      !is.na(immunity),
      immunity != "Hidden"
    ) |>
    distinct(version_season, order, episode, immune_castaway = castaway)

  vote_history |>
    left_join(
      immune,
      by = c("version_season", "episode", "order"),
      relationship = "many-to-many"
    ) |>
    filter(vote == immune_castaway)

  expect_equal(0, 0)
})

test_that("📜 Individual immunity assigned on vote history", {
  nobody_immune <- vote_history |>
    filter(tribe_status == "Merged") |>
    filter(vote_order == 1) |>
    group_by(version_season, version, season, episode, order) |>
    summarise(immunity_winner = sum(immunity %in% c("Individual", "Earned merge"), na.rm = TRUE)) |>
    filter(immunity_winner == 0)

  expect_equal(nrow(nobody_immune), 4)
})

test_that("📜 Winners on challenge_results match immunity on vote_history", {
  immunity_winners <- challenge_results |>
    filter(
      outcome_type == "Individual",
      challenge_type %in% c("Immunity", "Immunity and Reward"),
      result == "Won"
    ) |>
    distinct(version_season, episode, n_boots, castaway) |>
    mutate(immunity_winner = "Yes")


  x1 <- vote_history |>
    mutate(n_boots = order - 1) |>
    left_join(
      immunity_winners,
      by = c("version_season", "episode", "n_boots", "castaway")
    ) |>
    filter(
      immunity_winner == "Yes",
      is.na(immunity)
    ) |>
    nrow()

  expect_equal(x1, 14)
})

test_that("📜 Vote event consistency", {

  x1 <- vote_history |>
    count(vote_event) |>
    nrow()

  x2 <- vote_history |>
    mutate(vote_event = tolower(vote_event)) |>
    count(vote_event) |>
    nrow()

  expect_equal(x1, x2)

})


test_that("📜 Vote event outcome consistency", {

  x1 <- vote_history |>
    count(vote_event_outcome) |>
    nrow()

  x2 <- vote_history |>
    mutate(vote_event_outcome = tolower(vote_event_outcome)) |>
    count(vote_event_outcome) |>
    nrow()

  expect_equal(x1, x2)

})

test_that("📜 No new things in vote event", {

  acceptable_values <- c('Deadlock', 'Final 3 tribal', 'Countback', 'Nature quiz', 'Rock draw', 'Kidnapped', 'Quit', 'Fire challenge', 'Exiled', 'Won immunity challenge', 'Extra vote', 'Steal a vote', 'Unanimous decision', 'Vote blocker', 'Abstain to gain', 'Fire challenge (f4)', 'Ghost island game', 'Island of the idols game', 'Safety without power', 'Beware advantage', 'Shot in the dark', 'Do or die', 'Summit', 'Bank your vote', 'Control the vote', 'Player quit', 'Journey challenge', 'Sacrificed vote to extend idol', 'Sacrificed vote to extend idol; goodwill advantage', 'Lost vote at survivor auction', 'First out in challenge', 'Lost vote on journey', 'Dead man walking', 'Vote to kidnap', 'Trial by fire', 'Sick day', 'Exempt', 'Removed from tribal', 'Lost tribal council reward challenge', 'Ultimate vote played successfully', 'Black cowrie', 'Tiebreaker challenge', 'Island of secrets game', 'Traded vote', 'Stayed on immunity island', 'Tied destiny', 'Tribal council pass', 'No vote', 'Sudden death trivia', 'Vote stolen')

  vote_history |>
    filter(
      !vote_event %in% acceptable_values,
      !is.na(vote_event)
    ) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 No new things in vote event outcome", {

  acceptable_values <- c('Can\'t vote', 'Vote not required', 'Eliminated', 'Safe', 'Lost', 'Won', 'Immune', 'Removed from tribal', 'No vote', 'Extra vote', 'Lost vote', 'Saved', 'Not safe', 'Forced vote', 'Lost vote; gained vote', 'Exempt', 'Nullified all other votes', 'Additional vote')

  vote_history |>
    filter(
      !vote_event_outcome %in% acceptable_values,
      !is.na(vote_event_outcome)
    ) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 Castaway IDs OK", {

  vote_history |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 Vote IDs OK", {

  vote_history |>
    distinct(version_season, vote, vote_id) |>
    group_by(version_season, vote) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 Voted out IDs OK", {

  vote_history |>
    distinct(version_season, voted_out, voted_out_id) |>
    group_by(version_season, voted_out) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


# CHALLENGES --------------------------------------------------------------

test_that("🏆 Challenge summary and challenge results are the same size", {

  x1 <- challenge_summary |>
    distinct(version_season, challenge_id) |>
    nrow()

  x2 <- challenge_results |>
    filter(version == "US") |>
    distinct(version_season, challenge_id) |>
    nrow()

  expect_equal(x1, x2)

})


test_that("🏆 No castaway duplication within a challenge", {

  challenge_results |>
    group_by(version_season, challenge_id, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 Challenge type consistency", {

  acceptable_types <- c('Immunity and Reward', 'Reward', 'Immunity', 'Duel', 'Captains Duel')

  challenge_results |>
    filter(!challenge_type %in% acceptable_types) |>
    nrow() |>
    expect_equal(0)

})

test_that("🏆 No incorrect castaway IDs", {

  challenge_results |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})




# CASTAWAYS ---------------------------------------------------------------

test_that("🧑 Castaway details is unique", {
  nrows <- nrow(castaway_details)
  distinct_rows <- castaway_details |>
    distinct(castaway_id) |>
    nrow()

  expect_equal(nrows, distinct_rows)
})

test_that("🧑 No more than one winner", {
  x <- castaways |>
    group_by(version_season) |>
    summarise(
      n_jury = sum(jury),
      n_finalist = sum(finalist),
      n_winner = sum(winner)
    ) |>
    filter(n_winner != 1) |>
    nrow()

  expect_equal(x, 0)
})


test_that("🧑 Consistent results", {

  acceptable_values <- c('10th voted out', '11th voted out', '12th voted out', '13th voted out', '14th voted out', '15th voted out', '16th voted out', '17th voted out', '18th voted out', '19th voted out', '1st voted out', '20th voted out', '21st voted out', '22nd voted out', '23rd voted out', '2nd runner-up', '2nd voted out', '2nd voted out; Quit EoE', '3rd voted out', '3rd voted out; Quit', '4th voted out', '5th voted out', '6th voted out', '6th voted out; Quit EoE', '7th voted out', '8th voted out', '8th voted out; Quit EoE', '9th voted out', 'Ejected', 'Eliminated', 'Evacuated', 'Lost final 4 fire challenge', 'Lost fire challenge', 'Medically evacuated', 'Quit', 'Runner-up', 'Sole Survivor', 'Switched', 'Tied destiny', 'Withdrew')

  castaways |>
    filter(!result %in% acceptable_values) |>
    nrow() |>
    expect_equal(0)

})

# JURY --------------------------------------------------------------------

test_that("👩‍⚖️ Jury votes matches 'jury' on castaways", {

  jury <- survivoR::jury_votes |>
    group_by(version_season) |>
    summarise(n_jury = n_distinct(castaway))

  castaway <- survivoR::castaways |>
    group_by(version_season) |>
    summarise(n = sum(jury)) |>
    left_join(jury, by = "version_season") |>
    filter(
      n > 0,
      !version_season %in% c("SA05", "UK02"),
      n != n_jury
    ) |>
    nrow()

  expect_equal(castaway, 0)

})


test_that("👩‍⚖️ Jury count the same on castaways and jury votes", {

  x <- castaways |>
    group_by(version_season) |>
    summarise(
      n_jury = sum(jury),
      n_finalist = sum(finalist),
      n_winner = sum(winner)
    ) |>
    left_join(
      jury_votes |>
        group_by(version_season) |>
        summarise(
          n_jury_jv = n_distinct(castaway_id),
          n_finalist_jv = n_distinct(finalist_id)
        ),
      by = "version_season"
    ) |>
    filter(
      n_jury != n_jury_jv | n_finalist != n_finalist_jv
    ) |>
    nrow()

  expect_equal(x, 2)

})


test_that("👩‍⚖️ Finalist IDs OK", {

  jury_votes |>
    distinct(version_season, finalist, finalist_id) |>
    group_by(version_season, finalist) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("👩‍⚖️ Castaway IDs OK", {

  jury_votes |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("👩‍⚖️ The number of votes equals the number of jurors", {

  jury_votes |>
    group_by(version_season) |>
    summarise(
      n_jurors = n_distinct(castaway),
      n_votes = sum(vote)
    ) |>
    filter(n_jurors != n_votes) |>
    nrow() |>
    expect_equal(0)

})

# ADVANTAGES --------------------------------------------------------------

test_that("📿 Advantage Type consistency", {

  x1 <- advantage_details |>
    count(advantage_type) |>
    nrow()

  x2 <- advantage_details |>
    mutate(advantage_details = tolower(advantage_type)) |>
    count(advantage_type) |>
    nrow()

  expect_equal(x1, x2)

})




test_that("📿 No advantage ID's are missing", {

  advantage_details |>
    filter(is.na(advantage_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 Advantage sequence ID is in sequence", {

  advantage_movement |>
    group_by(version_season, advantage_id) |>
    summarise(
      min = min(sequence_id),
      max = max(sequence_id),
      n = n(),
      .groups = "drop"
    ) |>
    filter(min != 1 | max != n) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 There are no advantage ID dupes", {

  advantage_details %>%
    filter(!is.na(advantage_id)) %>%
    select(version, season, advantage_id) %>%
    group_by(version, season, advantage_id) %>%
    count() %>%
    filter(n > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 Advantage movement and details are synced", {

  advantage_movement %>%
    anti_join(advantage_details, join_by(version, season, advantage_id)) %>%
    select(version, season, advantage_id) %>%
    distinct() |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 There are sequential advantage IDs", {

  advantage_details %>%
    select(version, season, advantage_id) %>%
    group_by(version, season) %>%
    mutate(max_advantage_id = max(advantage_id)) %>%
    group_by(version, season, max_advantage_id) %>%
    count() %>%
    filter(max_advantage_id != n) |>
    nrow() |>
    expect_equal(1)

})


test_that("📿 Consistent advantage categories", {

  acceptable_types <- c('Hidden Immunity Idol', 'Super Idol', 'Extra Vote', 'Steal a Vote', 'Reward Stealer', 'Vote Blocker', 'Hidden Immunity Idol Half', 'Idol Nullifier', 'Advantage Menu', 'Knowledge is Power', 'Amulet', 'Choose your Champion', 'Challenge Advantage', 'Bank your Vote', 'Inheritance Advantage', 'Control the Vote', 'Safety without Power', 'Goodwill Advantage', 'Kidnap Castaway from Other Tribe', 'Moral Dilemma', 'Remove Jury Member', 'Vote Steal', 'Voter Remover', 'Ultimate Vote', 'Disadvantage Future Vote Cast Against you', 'Black Cowrie', 'Hidden Immunity Idol Clue', 'White Cowrie', 'Practice Advantage', 'Diplomatic Immunity', 'Tribal Council Pass', 'Outsurance Reward Send Token', 'Save the Date', 'Coin Flip')

  advantage_details |>
    filter(!advantage_type %in% acceptable_types) |>
    nrow() |>
    expect_equal(0)

})


# BOOT MAPPING ------------------------------------------------------------

test_that("🥾 No dupes in boot mapping", {

  expect_equal(
    boot_mapping |>
      nrow(),
    boot_mapping |>
      distinct() |>
      nrow()
  )

})

test_that("🥾 Castaway IDs are OK", {

  boot_mapping |>
    group_by(version_season, episode, order, castaway) |>
    filter(n()>1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🥾 Final N is OK", {

  boot_mapping |>
    filter(!is.na(final_n)) |>
    group_by(version_season) |>
    summarise(
      n = n_distinct(castaway[order == 0]),
      min = min(final_n),
      max = max(final_n)
    ) |>
    filter(n != max | min != 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🥾 Final N matches the number of castaways and IDs", {

  boot_mapping |>
    filter(!is.na(final_n)) |>
    group_by(version_season, final_n) |>
    summarise(
      n_castaway = n_distinct(castaway),
      n_castaway_id = n_distinct(castaway_id)
    ) |>
    filter(final_n != n_castaway | final_n != n_castaway_id) |>
    nrow() |>
    expect_equal(0)

})


# TRIBE MAPPING -----------------------------------------------------------

test_that("🧜‍♂️ No dupes in tribe mapping", {

  expect_equal(
    tribe_mapping |>
      nrow(),
    tribe_mapping |>
      distinct() |>
      nrow()
  )

})


# CONFESSIONALS -----------------------------------------------------------

test_that("💬 No dupes in confessionals", {

  confessionals |>
    group_by(version_season, episode) |>
    summarise(
      n = n(),
      n_cast = n_distinct(castaway),
      n_cast_id = n_distinct(castaway_id),
      .groups = "drop"
    ) |>
    filter(n_cast != n | n_cast_id != n) |>
    nrow() |>
    expect_equal(0)

})

test_that("💬 No other types of dupes", {

  confessionals |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})

# EPISODES ----------------------------------------------------------------

test_that("🔢 Episodes align with boot mapping", {

  df_ep <- episodes |>
    filter(!episode_label %in% c("Recap", "Reunion")) |>
    distinct(version_season, episode)

  df_bm <- boot_mapping |>
    distinct(version_season, episode)

  df_bm |>
    anti_join(df_ep, join_by(version_season, episode)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🔢 Episodes align with tribe mapping", {

  df_ep <- episodes |>
    filter(!episode_label %in% c("Recap", "Reunion")) |>
    distinct(version_season, episode)

  df_tm <- tribe_mapping |>
    distinct(version_season, episode)

  df_tm |>
    anti_join(df_ep, join_by(version_season, episode)) |>
    nrow() |>
    expect_equal(0)

})


# SEASON SUMMARY ----------------------------------------------------------

test_that("☀️ Season name consistent", {

  season_name <- bind_rows(
    "castaways" = castaways |>
      distinct(version_season, season_name),
    "boot_mapping" = boot_mapping |>
      distinct(version_season, season_name),
    "tribe_mapping" = tribe_mapping |>
      distinct(version_season, season_name),
    "vote_history" = vote_history |>
      distinct(version_season, season_name),
    "challenge_results" = challenge_results |>
      distinct(version_season, season_name),
    "challenge_description" = challenge_description |>
      distinct(version_season, season_name),
    "season_palettes" = season_palettes |>
      distinct(version_season, season_name),
    "jury_votes" = jury_votes |>
      distinct(version_season, season_name),
    "survivor_auction" = survivor_auction |>
      distinct(version_season, season_name),
    "auction_details" = auction_details |>
      distinct(version_season, season_name),
    .id = "table"
  )

  season_name |>
    anti_join(season_summary, by = join_by(season_name)) |>
    nrow() |>
    expect_equal(0)

})
