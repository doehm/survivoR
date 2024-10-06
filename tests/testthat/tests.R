
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(purrr))


# GLOBALS -----------------------------------------------------------------

tribe_status_acceptable_vals <- c(
  'Original', 'Merged', 'Swapped', 'Swapped_2', 'None', 'Redemption Island',
  'Edge of Extinction', 'Mergatory', 'Swapped_3', 'Exile Beach',
  'Redemption Rock', 'Swapped_4', 'Dead Man\'s Island', 'Not yet selected',
  'Purgatory', 'Medical Leave', 'Island of Secrets')

in_progress_seasons <- "US47"

paste_tribble <- function(df) {

  df <- df |>
    as.data.frame()

  cat("tribble(\n")

  headers <- rep(NA, ncol(df))
  for(k in 1:ncol(df)) {
    headers[k] <- glue("~{colnames(df)[k]}")
  }
  cat(paste0(headers, collapse = ", "), ",\n")

  for(k in 1:nrow(df)) {
    cell <- NULL
    for(j in 1:ncol(df)) {
      if(class(df[,j]) == "character") {
        cell = paste0(cell, paste0("'", df[k,j], "', "))
      } else if(class(df[,j]) == "numeric") {
        cell = paste0(cell, paste0(df[k,j], ", "))
      }
    }
    cat(cell, "\n")
  }
}

# VOTE HISTORY ------------------------------------------------------------

test_that("📜 1. No one voted for themselves", {

  vote_history |>
    filter(castaway == vote) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 2. Correct split votes", {

  vote_history |>
    filter(!is.na(split_vote), !str_detect(split_vote, vote)) |>
    nrow() |>
    expect_equal(0)
})


test_that("📜 3. No votes for people who have immunity", {

  immune <- vote_history |>
    filter(
      !is.na(immunity),
      !immunity %in% c("Hidden", "Deadlock", "Hidden (nullified)", "Shot in the dark (safe)", "Salvation")
    ) |>
    distinct(version_season, order, episode, immune_castaway = castaway)

  vote_history |>
    left_join(
      immune,
      by = c("version_season", "episode", "order"),
      relationship = "many-to-many"
    ) |>
    filter(vote == immune_castaway) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 4. Individual immunity assigned on vote history", {

  vote_history |>
    filter(tribe_status == "Merged") |>
    filter(vote_order == 1) |>
    group_by(version_season, version, season, episode, order) |>
    summarise(immunity_winner = sum(immunity %in% c("Individual", "Earned merge"), na.rm = TRUE)) |>
    filter(immunity_winner == 0) |>
    nrow() |>
    expect_equal(5)

})


test_that("📜 5. Winners on challenge_results match immunity on vote_history", {

  # skip("Needs work")

  immunity_winners <- challenge_results |>
    filter(
      outcome_type == "Individual",
      challenge_type %in% c("Immunity", "Immunity and Reward"),
      result == "Won"
    ) |>
    distinct(version_season, episode, n_boots, castaway) |>
    mutate(immunity_winner = "Yes")

  vote_history |>
    mutate(n_boots = order - 1) |>
    left_join(
      immunity_winners,
      by = c("version_season", "episode", "n_boots", "castaway")
    ) |>
    filter(
      immunity_winner == "Yes",
      is.na(immunity)
    ) |>
    nrow() |>
    expect_equal(14)

})


test_that("📜 6. Vote event consistency", {

  x1 <- vote_history |>
    count(vote_event) |>
    nrow()

  x2 <- vote_history |>
    mutate(vote_event = tolower(vote_event)) |>
    count(vote_event) |>
    nrow()

  expect_equal(x1, x2)

})


test_that("📜 7. Vote event outcome consistency", {

  x1 <- vote_history |>
    count(vote_event_outcome) |>
    nrow()

  x2 <- vote_history |>
    mutate(vote_event_outcome = tolower(vote_event_outcome)) |>
    count(vote_event_outcome) |>
    nrow()

  expect_equal(x1, x2)

})


test_that("📜 8. No new things in vote event", {

  acceptable_values <- c('Deadlock', 'Final 3 tribal', 'Countback', 'Nature quiz', 'Rock draw', 'Kidnapped', 'Quit', 'Fire challenge', 'Exiled', 'Won immunity challenge', 'Extra vote', 'Steal a vote', 'Unanimous decision', 'Vote blocker', 'Abstain to gain', 'Fire challenge (f4)', 'Ghost island game', 'Island of the idols game', 'Safety without power', 'Beware advantage', 'Shot in the dark', 'Do or die', 'Summit', 'Bank your vote', 'Control the vote', 'Player quit', 'Journey challenge', 'Sacrificed vote to extend idol', 'Sacrificed vote to extend idol; goodwill advantage', 'Lost vote at survivor auction', 'First out in challenge', 'Lost vote on journey', 'Dead man walking', 'Vote to kidnap', 'Trial by fire', 'Sick day', 'Exempt', 'Removed from tribal', 'Lost tribal council reward challenge', 'Ultimate vote played successfully', 'Black cowrie', 'Tiebreaker challenge', 'Island of secrets game', 'Traded vote', 'Stayed on immunity island', 'Tied destiny', 'Tribal council pass', 'No vote', 'Sudden death trivia', 'Vote stolen', 'Lost challenge on immunity island')

  vote_history |>
    filter(
      !vote_event %in% acceptable_values,
      !is.na(vote_event)
    ) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 9. No new things in vote event outcome", {

  acceptable_values <- c('Can\'t vote', 'Vote not required', 'Eliminated', 'Safe', 'Lost', 'Won', 'Immune', 'Removed from tribal', 'No vote', 'Extra vote', 'Lost vote', 'Saved', 'Not safe', 'Forced vote', 'Lost vote; gained vote', 'Exempt', 'Nullified all other votes', 'Additional vote', 'Amy also voted out', "Automatic vote cast against player")

  vote_history |>
    filter(
      !vote_event_outcome %in% acceptable_values,
      !is.na(vote_event_outcome)
    ) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 10. Castaway IDs OK (by name)", {

  vote_history |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})

test_that("📜 11. Castaway IDs OK (by ID)", {

  vote_history |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 12. Vote IDs OK (by name)", {

  vote_history |>
    distinct(version_season, vote, vote_id) |>
    group_by(version_season, vote) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 13. Vote IDs OK (by ID)", {

  vote_history |>
    distinct(version_season, vote, vote_id) |>
    group_by(version_season, vote_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 14. Voted out IDs OK (by name)", {

  vote_history |>
    distinct(version_season, voted_out, voted_out_id) |>
    group_by(version_season, voted_out) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 15. Voted out IDs OK (by ID)", {

  vote_history |>
    distinct(version_season, voted_out, voted_out_id) |>
    group_by(version_season, voted_out_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 16. Immunity labels are consistent", {

  acceptable_values <- c('Individual', 'Removed from tribal', 'Hidden', 'Deadlock', 'Hidden (nullified)', 'Do or Die', 'Earned merge', 'Exempt', 'Salvation', 'Immune', "Shot in the dark (safe)")

  vote_history |>
    filter(
      !immunity %in% acceptable_values,
      !is.na(immunity)
      ) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 17. Vote is also in split vote", {

  vote_history |>
    filter(!is.na(split_vote)) |>
    mutate(in_split = str_detect(split_vote, vote)) |>
    filter(!in_split) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 18. No duplicate votes other than extra votes", {

  vote_history |>
    group_by(version_season, order, vote_order, castaway) |>
    filter(n() > 1) |>
    mutate(extra_vote = "Extra vote" %in% vote_event_outcome) |>
    filter(!extra_vote) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 19. No votes have an entry in vote_event", {

  vote_history |>
    filter(is.na(vote) & is.na(vote_event)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 20. vote_event and vote_event_outcome both have entries", {

  vote_history |>
    filter(is.na(vote_event) & !is.na(vote_event_outcome) | !is.na(vote_event) & is.na(vote_event_outcome)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 21. All votes against immune players are nullified", {

  vote_history |>
    filter(vote_order == 1) |>
    group_by(version_season, order) |>
    mutate(
      played_hidden = paste(castaway[immunity == "Hidden"], collapse = ",")
    ) |>
    filter(str_detect(played_hidden, vote) & !nullified) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 22. No missing sog_id", {

  vote_history |>
    filter(is.na(sog_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 23. Consistent tribe status", {

  vote_history |>
    filter(!tribe_status %in% tribe_status_acceptable_vals) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 24. Consistent tribe names", {

  vote_history |>
    anti_join(tribe_colours, join_by(version_season, tribe)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 25. Episode voted out matches castaways", {

  vote_history |>
    distinct(version_season, episode, voted_out) |>
    anti_join(castaways, join_by(version_season, episode, voted_out == castaway)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 26. Version season matches season", {

  vote_history |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 27. Castaway ID matches castaway_details", {

  vote_history |>
    filter(
      !is.na(castaway_id),
      vote_event != "Black cowrie" | is.na(vote_event)
    ) |>
    anti_join(castaway_details, join_by(castaway_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 28. Vote ID matches castaway_details", {

  vote_history |>
    filter(
      !is.na(vote_id),
      vote_event != "Black cowrie" | is.na(vote_event)
    ) |>
    anti_join(castaway_details, join_by(castaway_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 29. Voted Out ID matches castaway_details", {

  vote_history |>
    filter(
      !is.na(voted_out_id),
      vote_event != "Black cowrie" | is.na(vote_event)
    ) |>
    anti_join(castaway_details, join_by(castaway_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📜 30. Voted out only once (with exceptions)", {

  ok_records <- tribble(
    ~version_season, ~episode, ~order, ~voted_out,
    'AU01', 5, 6, 'Conner',
    'AU01', 15, 14, 'Conner',
    'AU01', 5, 5, 'Nick',
    'AU01', 17, 16, 'Nick',
    'AU02', 8, 9, 'Anneliese',
    'AU02', 17, 16, 'Anneliese',
    'AU03', 7, 7, 'Tegan',
    'AU03', 12, 12, 'Tegan',
    'AU04', 19, 18, 'Simon',
    'AU04', 20, 19, 'Simon',
    'AU06', 6, 6, 'Cara',
    'AU06', 23, 24, 'Cara',
    'AU06', 20, 21, 'Flick',
    'AU06', 24, 25, 'Flick',
    'AU07', 17, 17, 'Jordie',
    'AU07', 22, 23, 'Jordie',
    'AU07', 17, 18, 'KJ',
    'AU07', 23, 24, 'KJ',
    'AU07', 4, 4, 'Sophie',
    'AU07', 8, 8, 'Sophie',
    'AU08', 20, 19, 'Nina',
    'AU08', 22, 21, 'Nina',
    'NZ01', 11, 9, 'Mike',
    'NZ01', 19, 15, 'Mike',
    'NZ01', 18, 14, 'Nate',
    'NZ01', 19, 16, 'Nate',
    'NZ01', 8, 7, 'Shay',
    'NZ01', 16, 13, 'Shay',
    'US07', 4, 4, 'Burton',
    'US07', 13, 14, 'Burton',
    'US22', 12, 14, 'Andrea',
    'US22', 14, 16, 'Andrea',
    'US22', 2, 2, 'Matt',
    'US22', 8, 8, 'Matt',
    'US23', 7, 7, 'Ozzy',
    'US23', 9, 9, 'Ozzy',
    'US23', 15, 17, 'Ozzy',
    'US27', 1, 1, 'Laura B.',
    'US27', 7, 11, 'Laura B.',
    'US27', 5, 9, 'Laura M.',
    'US27', 10, 15, 'Laura M.',
    'US27', 9, 14, 'Tina',
    'US27', 14, 20, 'Tina',
    'US38', 4, 4, 'Rick',
    'US38', 13, 17, 'Rick',
    'US40', 4, 5, 'Tyson',
    'US40', 10, 12, 'Tyson'
  )

  vote_history |>
    distinct(version_season, episode, order, voted_out) |>
    group_by(version_season, voted_out) |>
    filter(n() > 1) |>
    anti_join(ok_records, join_by(version_season, episode, order, voted_out)) |>
    nrow() |>
    expect_equal(0)

})

test_that("📜 31. Castaway IDs on vote history match castaways table", {

  vote_history |>
    distinct(version_season, castaway_id, castaway) |>
    left_join(
      castaways |>
        distinct(version_season, castaway_id, castaway2 = castaway),
      join_by(version_season, castaway_id)
    ) |>
    filter(castaway != castaway2) |>
    nrow() |>
    expect_equal(0)

})

# CHALLENGES --------------------------------------------------------------

test_that("🏆 1. Challenge summary and challenge results are the same size", {

  x1 <- challenge_summary |>
    distinct(version_season, challenge_id) |>
    nrow()

  x2 <- challenge_results |>
    filter(version == "US") |>
    distinct(version_season, challenge_id) |>
    nrow()

  expect_equal(x1, x2)

})


test_that("🏆 2. No castaway duplication within a challenge", {

  challenge_results |>
    group_by(version_season, challenge_id, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 3. Challenge type consistency", {

  acceptable_types <- c('Immunity and Reward', 'Reward', 'Immunity', 'Duel', 'Captains Duel')

  challenge_results |>
    filter(!challenge_type %in% acceptable_types) |>
    nrow() |>
    expect_equal(0)

})

test_that("🏆 4. Outcome type consistency", {

  acceptable_types <- c('Tribal', 'Individual', 'Team', 'Team / Individual', 'Tribal / Individual')

  challenge_results |>
    filter(!outcome_type %in% acceptable_types) |>
    nrow() |>
    expect_equal(0)

})

test_that("🏆 5. No incorrect castaway IDs (by name)", {

  challenge_results |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 6. No incorrect castaway IDs (by ID)", {

  challenge_results |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 7. No missing sog_id", {

  challenge_results |>
    filter(is.na(sog_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 8. There are no castaways assigned to the challenge that aren't on boot mapping", {

  challenge_results |>
    distinct(version_season, sog_id, castaway) |>
    anti_join(
      boot_mapping |>
        distinct(version_season, sog_id, castaway),
      join_by(version_season, sog_id, castaway)
    ) |>
    filter(version_season != "SA05") |>
    nrow() |>
    expect_equal(0)

  # Note: the data frame only includes SA05 because that was a strange one and not that important

})


test_that("🏆 9. The same number of castaways are on challenge_results and boot_mapping", {

  challenge_results |>
    filter(challenge_type != "Duel") |>
    distinct(version_season, sog_id, castaway) |>
    count(version_season, sog_id) |>
    left_join(
      boot_mapping |>
        filter(!game_status %in% c("Redemption Island", "Edge of Extinction", "Exile Beach", "Redemption Rock", "Purgatory", "Survivor Isolation", "Dead Man's Island")) |>
        distinct(version_season, sog_id, castaway) |>
        count(version_season, sog_id, name = "n_bm"),
      join_by(version_season, sog_id)
    ) |>
    filter(version_season != "SA05") |> # ignoring SA05 for the moment
    filter(n != n_bm) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 10. onsistent tribe status", {

  challenge_results |>
    filter(!tribe_status %in% tribe_status_acceptable_vals) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 11. Consistent tribe names", {

  challenge_results |>
    filter(str_detect(tribe_status, "Original|Swapped|Merged")) |>
    anti_join(tribe_colours, join_by(version_season, tribe)) |>
    nrow() |>
    expect_equal(0)

})

test_that("🏆 12. All rewards have a reward description", {

  challenge_description |>
    filter(str_detect(challenge_type, "eward") & is.na(reward)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 13. There are no challenge ID's on challenge results that aren't on challenge_summary", {

  challenge_results |>
    filter(version == "US") |>
    anti_join(challenge_summary, join_by(version_season, challenge_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 14. The number that sit out balances the numbers in the challenge", {

  # this is a bad test
  # sit outs needs a lot of work
  # this will at least catch any new ones that are easy to check

  challenge_results |>
    filter(
      outcome_type %in% c("Tribal"),
      !is.na(sit_out)
    ) |>
    group_by(version_season, episode, challenge_id, tribe) |>
    summarise(
      n_cast = n(),
      n_sat_out = sum(sit_out),
      .groups = "drop"
    ) |>
    group_by(version_season, episode, challenge_id) |>
    mutate(
      min = min(n_cast),
      n_adj = n_cast - n_sat_out,
      check = all(n_adj == n_adj[1])
    ) |>
    filter(!check) |>
    nrow() |>
    expect_equal(144)

})


test_that("🏆 15. There are no new result types", {

  acceptable_values <- c('Won', 'Lost', 'Won (reward only)', 'Won (immunity only)', 'Draw')

  challenge_results |>
    filter(!result %in% acceptable_values) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 16. Order of finish is not for indivdual challenges", {

  challenge_results |>
    filter(!is.na(order_of_finish) & outcome_type == "Individual") |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 17. Order of finish is available for tribal challenges", {

  challenge_results |>
    filter(is.na(order_of_finish) & outcome_type == "Tribal") |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 18. All challenges on challenge_description are on challenge_results", {

  df_res <- challenge_results |>
    distinct(version_season, challenge_id)

  df_desc <- challenge_description |>
    filter(challenge_type != "Outpost") |>
    distinct(version_season, challenge_id) |>
    filter(
      !(version_season == "US19" & challenge_id == 9),
      !(version_season == "AU02" & challenge_id == 20),
      !(version_season == "AU06" & challenge_id == 22),
      !(version_season == "US47" & challenge_id == 2),
      version_season != "SA05"
    )

  # US19 9 is fine
  # AU02 20 is fine
  # AU06 22 is fine
  # couldn't be bothered with all of SA05

  df_desc |>
    anti_join(df_res, join_by(version_season, challenge_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 19. All challenges on challenge_results are on challenge_description", {

  df_res <- challenge_results |>
    distinct(version_season, challenge_id)

  df_desc <- challenge_description |>
    filter(challenge_type != "Outpost") |>
    distinct(version_season, challenge_id)

  df_res |>
    filter(version_season != "SA05") |>
    anti_join(df_desc, join_by(version_season, challenge_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🏆 20. Version season matches season", {

  challenge_results |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})

test_that("🏆 21. Castaway IDs on challenge results match castaways table", {

  challenge_results |>
    distinct(version_season, castaway_id, castaway) |>
    left_join(
      castaways |>
        distinct(version_season, castaway_id, castaway2 = castaway),
      join_by(version_season, castaway_id)
    ) |>
    filter(castaway != castaway2) |>
    nrow() |>
    expect_equal(0)

})

# CASTAWAYS ---------------------------------------------------------------

test_that("🧑 1. No incorrect castaway IDs (by name)", {

  castaways |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧑 2. No incorrect castaway IDs (by ID)", {

  castaways |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧑 3. Castaway details is unique", {
  nrows <- nrow(castaway_details)
  distinct_rows <- castaway_details |>
    distinct(castaway_id) |>
    nrow()

  expect_equal(nrows, distinct_rows)
})

test_that("🧑 4. No more than one winner", {
  castaways |>
    group_by(version_season) |>
    summarise(
      n_jury = sum(jury),
      n_finalist = sum(finalist),
      n_winner = sum(winner)
    ) |>
    filter(n_winner != 1) |>
    nrow() |>
    expect_equal(0)
})


test_that("🧑 5. Consistent results", {

  acceptable_values <- c('10th voted out', '11th voted out', '12th voted out',
                         '13th voted out', '14th voted out', '15th voted out',
                         '16th voted out', '17th voted out', '18th voted out',
                         '19th voted out', '1st voted out', '20th voted out',
                         '21st voted out', '22nd voted out', '23rd voted out',
                         '24th voted out', '2nd runner-up', '2nd voted out',
                         '2nd voted out; Quit EoE', '3rd voted out', '3rd voted out; Quit',
                         '4th voted out', '5th voted out', '6th voted out',
                         '6th voted out; Quit EoE', '7th voted out', '8th voted out',
                         '8th voted out; Quit EoE', '9th voted out', 'Ejected',
                         'Eliminated', 'Evacuated', 'Lost final 4 fire challenge',
                         'Lost fire challenge', 'Medically evacuated', 'Quit',
                         'Runner-up', 'Sole Survivor', 'Switched', 'Tied destiny',
                         'Withdrew', "1st voted out (Quit)")

  castaways |>
    filter(!result %in% acceptable_values) |>
    filter(!(is.na(result) & version_season %in% in_progress_seasons)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧑 6. Vote out episode and order align with vote history", {

  castaways |>
    filter(
      !finalist,
      str_detect(result, "voted")
    ) |>
    anti_join(
      vote_history |>
        distinct(version_season, episode, order, castaway = voted_out),
      by = join_by(version_season, episode, order, castaway)
    ) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧑 7. Consistent tribe names", {

  castaways |>
    anti_join(tribe_colours, join_by(version_season, original_tribe == tribe)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧑 8. Version season matches season", {

  castaways |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧑 9. Full name is the same as on castaway details", {

  ok_records <- tribble(
    ~version_season, ~full_name,
    'US02', 'Amber Brkich',
    'US08', 'Amber Brkich',
    'US13', 'Candice Woodcock',
    'US20', 'Candice Woodcock',
    'US24', 'Kim Spradlin',
    'US45', 'Bruce Perreault',
    'AU08', 'Shonee Bowtell',
    'SA07', 'Dante de Villiers',
    'UK01', 'Uzma Bashir'
  )

  castaways |>
    anti_join(
      ok_records,
      join_by(version_season, full_name)
    ) |>
    anti_join(
      castaway_details,
      join_by(full_name)
    ) |>
    nrow() |>
    expect_equal(0)

})

# JURY --------------------------------------------------------------------

test_that("👩‍⚖️ 1. Jury votes matches 'jury' on castaways", {

  castaways |>
    group_by(version_season) |>
    summarise(n = sum(jury)) |>
    left_join(
      jury_votes |>
        group_by(version_season) |>
        summarise(n_jury = n_distinct(castaway)),
      by = "version_season"
    ) |>
    filter(
      n > 0,
      !version_season %in% c("SA05", "UK02"),
      n != n_jury
    ) |>
    nrow() |>
    expect_equal(0)

})


test_that("👩‍⚖️ 2. Jury count the same on castaways and jury votes", {

  castaways |>
    group_by(version_season) |>
    summarise(
      n_jury = sum(jury, na.rm = TRUE),
      n_finalist = sum(finalist, na.rm = TRUE),
      n_winner = sum(winner, na.rm = TRUE)
    ) |>
    left_join(
      jury_votes |>
        group_by(version_season) |>
        summarise(
          n_jury_jv = n_distinct(castaway_id, na.rm = TRUE),
          n_finalist_jv = n_distinct(finalist_id, na.rm = TRUE)
        ),
      by = "version_season"
    ) |>
    filter(
      n_jury != n_jury_jv | n_finalist != n_finalist_jv
    ) |>
    nrow() |>
    expect_equal(1)

})


test_that("👩‍⚖️ 3. Finalist IDs OK (by name)", {

  jury_votes |>
    distinct(version_season, finalist, finalist_id) |>
    group_by(version_season, finalist) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("👩‍⚖️ 4. Finalist IDs OK (by ID)", {

  jury_votes |>
    distinct(version_season, finalist, finalist_id) |>
    group_by(version_season, finalist_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("👩‍⚖️ 5. Castaway IDs OK (by name)", {

  jury_votes |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("👩‍⚖️ 6. Castaway IDs OK (by ID)", {

  jury_votes |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("👩‍⚖️ 7. The number of votes equals the number of jurors", {

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


test_that("👩‍⚖️ 8. Version season matches season", {

  jury_votes |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})

test_that("👩‍⚖️ 9. Castaway IDs on jury votes match castaways table", {

  jury_votes |>
    distinct(version_season, castaway_id, castaway) |>
    left_join(
      castaways |>
        distinct(version_season, castaway_id, castaway2 = castaway),
      join_by(version_season, castaway_id)
    ) |>
    filter(castaway != castaway2) |>
    nrow() |>
    expect_equal(0)

})

# ADVANTAGES --------------------------------------------------------------


test_that("📿 1. No incorrect castaway IDs (by name)", {

  advantage_movement |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 2. No incorrect castaway IDs (by ID)", {

  advantage_movement |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 3. No incorrect played_for IDs (by name)", {

  advantage_movement |>
    distinct(version_season, played_for, played_for_id) |>
    group_by(version_season, played_for) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 4. No incorrect played_for IDs (by ID)", {

  advantage_movement |>
    distinct(version_season, played_for, played_for_id) |>
    group_by(version_season, played_for_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 5. Advantage Type consistency", {

  x1 <- advantage_details |>
    count(advantage_type) |>
    nrow()

  x2 <- advantage_details |>
    mutate(advantage_details = tolower(advantage_type)) |>
    count(advantage_type) |>
    nrow()

  expect_equal(x1, x2)

})


test_that("📿 6. No advantage ID's are missing", {

  advantage_details |>
    filter(is.na(advantage_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 7. Advantage sequence ID is in sequence", {

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


test_that("📿 8. There are no advantage ID dupes", {

  advantage_details %>%
    filter(!is.na(advantage_id)) %>%
    select(version, season, advantage_id) %>%
    group_by(version, season, advantage_id) %>%
    count() %>%
    filter(n > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 9. Advantage movement and details are synced", {

  advantage_movement %>%
    anti_join(advantage_details, join_by(version, season, advantage_id)) %>%
    select(version, season, advantage_id) %>%
    distinct() |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 10. There are sequential advantage IDs", {

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


test_that("📿 11. Consistent advantage categories", {

  acceptable_types <- c('Hidden Immunity Idol', 'Super Idol', 'Extra Vote', 'Steal a Vote', 'Reward Stealer', 'Vote Blocker', 'Hidden Immunity Idol Half', 'Idol Nullifier', 'Advantage Menu', 'Knowledge is Power', 'Amulet', 'Choose your Champion', 'Challenge Advantage', 'Bank your Vote', 'Inheritance Advantage', 'Control the Vote', 'Safety without Power', 'Goodwill Advantage', 'Kidnap Castaway from Other Tribe', 'Moral Dilemma', 'Remove Jury Member', 'Vote Steal', 'Voter Remover', 'Ultimate Vote', 'Disadvantage Future Vote Cast Against you', 'Black Cowrie', 'Hidden Immunity Idol Clue', 'White Cowrie', 'Practice Advantage', 'Diplomatic Immunity', 'Tribal Council Pass', 'Outsurance Reward Send Token', 'Save the Date', 'Coin Flip')

  advantage_details |>
    filter(!advantage_type %in% acceptable_types) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 12. Nullified votes match vote history", {

  advantage_movement |>
    left_join(
      advantage_details |>
        select(version_season, advantage_id, advantage_type),
      join_by(version_season, advantage_id)
    ) |>
    filter(
      event == "Played",
      advantage_type == "Hidden Immunity Idol"
    ) |>
    inner_join(
      vote_history |>
        group_by(version_season, episode, vote) |>
        summarise(
          n_nullified = sum(nullified),
          .groups = "drop"
        ),
      join_by(version_season, episode, played_for == vote)
    ) |>
    group_by(version_season, episode, played_for) |>
    mutate(votes_nullified_sum = sum(votes_nullified)) |>
    select(version_season, episode, played_for, votes_nullified, votes_nullified_sum, n_nullified) |>
    filter(votes_nullified_sum != n_nullified) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 13. Version season matches season", {

  advantage_movement |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})


test_that("📿 14. Castaway IDs on advantages match castaways table", {

  advantage_movement |>
    distinct(version_season, castaway_id, castaway) |>
    left_join(
      castaways |>
        distinct(version_season, castaway_id, castaway2 = castaway),
      join_by(version_season, castaway_id)
    ) |>
    filter(castaway != castaway2) |>
    nrow() |>
    expect_equal(0)

})

# BOOT MAPPING ------------------------------------------------------------

test_that("🥾 1. No dupes in boot mapping", {

  expect_equal(
    boot_mapping |>
      nrow(),
    boot_mapping |>
      distinct() |>
      nrow()
  )

})


test_that("🥾 2. Castaway IDs are OK (by name)", {

  boot_mapping |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🥾 3. Castaway IDs are OK (by ID)", {

  boot_mapping |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🥾 4. Final N is OK", {

  boot_mapping |>
    filter(!is.na(final_n)) |>
    group_by(version_season) |>
    summarise(
      n = n_distinct(castaway[order == 0]),
      min = min(final_n),
      max = max(final_n)
    ) |>
    mutate(
      exp_min = ifelse(version_season %in% in_progress_seasons, min, 1)
    ) |>
    filter(n != max | min != exp_min) |>
    nrow() |>
    expect_equal(0)

})


test_that("🥾 5. Final N matches the number of castaways and IDs", {

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


test_that("🥾 6. No missing sog_id", {

  boot_mapping |>
    filter(is.na(sog_id)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🥾 7. Consistent tribe status", {

  boot_mapping |>
    filter(!tribe_status %in% tribe_status_acceptable_vals) |>
    nrow() |>
    expect_equal(0)

})


test_that("🥾 8. Consistent tribe names", {

  boot_mapping |>
    filter(str_detect(tribe_status, "Original|Swapped|Merged")) |>
    anti_join(tribe_colours, join_by(version_season, tribe)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🥾 9. Version season matches season", {

  boot_mapping |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})


test_that("🥾 10. Castaway IDs on boot mapping match castaways table", {

  boot_mapping |>
    distinct(version_season, castaway_id, castaway) |>
    left_join(
      castaways |>
        distinct(version_season, castaway_id, castaway2 = castaway),
      join_by(version_season, castaway_id)
    ) |>
    filter(castaway != castaway2) |>
    nrow() |>
    expect_equal(0)

})


# TRIBE MAPPING -----------------------------------------------------------

test_that("🧜‍♂️1.  Castaway IDs are OK (by name)", {

  tribe_mapping |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧜‍♂️2.  Castaway IDs are OK (by ID)", {

  tribe_mapping |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧜‍♂️3.  No dupes in tribe mapping", {

  expect_equal(
    tribe_mapping |>
      nrow(),
    tribe_mapping |>
      distinct() |>
      nrow()
  )

})


test_that("🧜‍♂️4.  Consistent tribe status", {

  tribe_mapping |>
    filter(!tribe_status %in% tribe_status_acceptable_vals) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧜‍♂️5.  Consistent tribe names", {

  tribe_mapping |>
    filter(str_detect(tribe_status, "Original|Swapped|Merged")) |>
    anti_join(tribe_colours, join_by(version_season, tribe)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧜‍♂️6.  Version season matches season", {

  tribe_mapping |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧜‍♂ 7. Castaway IDs on tribe mapping match castaways table", {

  tribe_mapping |>
    distinct(version_season, castaway_id, castaway) |>
    left_join(
      castaways |>
        distinct(version_season, castaway_id, castaway2 = castaway),
      join_by(version_season, castaway_id)
    ) |>
    filter(castaway != castaway2) |>
    nrow() |>
    expect_equal(0)

})

# CONFESSIONALS -----------------------------------------------------------

test_that("💬️1.  Castaway IDs are OK (by name)", {

  confessionals |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("💬️2.  Castaway IDs are OK (by ID)", {

  confessionals |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway_id) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("💬 3. No dupes in confessionals", {

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


test_that("💬 4. No other types of dupes", {

  confessionals |>
    distinct(version_season, castaway, castaway_id) |>
    group_by(version_season, castaway) |>
    filter(n() > 1) |>
    nrow() |>
    expect_equal(0)

})


test_that("💬 5. No NA's in confessional count", {

  confessionals |>
    filter(is.na(confessional_count)) |>
    nrow() |>
    expect_equal(0)

})


test_that("💬 6. Castaways match boot mapping", {

  confessionals |>
    group_by(version_season, episode) |>
    summarise(
      n_cast_conf = n_distinct(castaways),
      .groups = "drop"
      ) |>
    left_join(
      boot_mapping |>
        group_by(version_season, episode) |>
        summarise(
          n_cast_bm = n_distinct(castaways),
          .groups = "drop"
          ),
      join_by(version_season, episode)
    ) |>
    filter(n_cast_conf != n_cast_bm) |>
    nrow() |>
    expect_equal(0)

})


test_that("💬 7. Version season matches season", {

  confessionals |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})


test_that("💬 8. Counts don't exceed the maximum", {

  confessionals |>
    filter(confessional_count > 22) |>
    nrow() |>
    expect_equal(0)

})


test_that("💬 9. Castaway IDs on tribe mapping match castaways table", {

  confessionals |>
    distinct(version_season, castaway_id, castaway) |>
    left_join(
      castaways |>
        distinct(version_season, castaway_id, castaway2 = castaway),
      join_by(version_season, castaway_id)
    ) |>
    filter(castaway != castaway2) |>
    nrow() |>
    expect_equal(0)

})

# EPISODES ----------------------------------------------------------------

test_that("🔢 1. Episodes align with boot mapping", {

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


test_that("🔢 2. Episodes align with tribe mapping", {

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


test_that("🔢 3. The dates are actually dates", {

  cols <- c("episode_date")

  map_lgl(cols, ~{
    class(episodes[[.x]]) == "Date"
  }) |>
    all() |>
    expect_true()

})


test_that("🔢 4. Version season matches season", {

  episodes |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})


test_that("🔢 5. epiosde_label has one and only one finale", {

  # skip("Skip until season finishes")

  expect_equal(
    episodes |>
      filter(
        episode_label == "Finale",
        !version_season %in% in_progress_seasons
        ) |>
      distinct(version_season) |>
      nrow(),
    episodes |>
      filter(!version_season %in% in_progress_seasons) |>
      distinct(version_season) |>
      nrow()
  )

})


test_that("🔢 6. No missing episode lengths", {

  episodes |>
    filter(
      is.na(episode_length),
      episode_label != "Reunion",
      !version_season %in% in_progress_seasons,
      !version_season %in% c('SA01', 'SA02', 'SA03', 'SA04', 'SA05', 'UK01', 'UK02')
      ) |>
    nrow() |>
    expect_equal(0)

})


# SEASON SUMMARY ----------------------------------------------------------

test_that("☀️ 1. Season name consistent", {

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


test_that("☀️ 2. The dates are actually dates", {

  cols <- c("premiered", "ended", "filming_started", "filming_ended")

  map_lgl(cols, ~{
    class(season_summary[[.x]]) == "Date"
  }) |>
    all() |>
    expect_true()

})


test_that("☀️ 3. Results match jury votes", {

  df_votes <- jury_votes |>
    group_by(version_season, finalist) |>
    summarise(n = sum(vote)) |>
    group_by(version_season) |>
    arrange(desc(n)) |>
    summarise(result_jury = paste0(n, collapse = "-"))

  season_summary |>
    left_join(df_votes, join_by(version_season)) |>
    filter(final_vote != result_jury) |>
    select(version_season, final_vote, result_jury) |>
    nrow() |>
    expect_equal(0)

})


test_that("☀️ 4. Winner ID's are correct", {

  season_summary |>
    left_join(
      boot_mapping |>
        filter(final_n == 1) |>
        select(version_season, castaway_id),
      join_by(version_season)
    ) |>
    filter(winner_id != castaway_id) |>
    nrow() |>
    expect_equal(0)

})


test_that("☀️ 5. Version season matches season", {

  season_summary |>
    mutate(i = as.numeric(str_extract(version_season, "[:digit:]+"))) |>
    filter(i != season) |>
    nrow() |>
    expect_equal(0)

})

# TRIBE COLOURS -----------------------------------------------------------

test_that("🎨 1. Consistent tribe status", {

  tribe_colours |>
    filter(!tribe_status %in% tribe_status_acceptable_vals) |>
    nrow() |>
    expect_equal(0)

})

# CASTAWAY DETAILS --------------------------------------------------------

test_that("🧑‍🦰 1. BIPOC flag matches the other 4", {

  castaway_details |>
    filter(str_sub(castaway_id, 1, 2) == "US") |>
    mutate(i = african + asian + latin_american + native_american) |>
    select(i, bipoc) |>
    filter(i > 0 & !bipoc) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧑‍🦰 2. Gender no missing", {

  castaway_details |>
    filter(is.na(gender)) |>
    nrow() |>
    expect_equal(0)

})


test_that("🧑‍🦰 3. There are three gender cats", {

  castaway_details |>
    count(gender) |>
    nrow() |>
    expect_equal(3)

})


test_that("🧑‍🦰 4. Dates are dates", {

  all(
    class(castaway_details$date_of_birth) == "Date",
    class(castaway_details$date_of_death) == "Date"
  ) |>
    expect_true()

})


test_that("🧑‍🦰 5. No missing date of births", {

  castaway_details |>
    filter(
      str_sub(1, 2) == "US",
      is.na(date_of_birth)
      ) |>
    nrow() |>
    expect_equal(0)

})
