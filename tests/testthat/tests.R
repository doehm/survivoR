library(dplyr)
library(stringr)

test_that("no one voted for themselves", {
  x <- vote_history |>
    filter(castaway == vote)

  expect_equal(nrow(x), 0)
})

test_that("Castaway details is unique", {
  nrows <- nrow(castaway_details)
  distinct_rows <- castaway_details |>
    distinct(castaway_id) |>
    nrow()

  expect_equal(nrows, distinct_rows)
})

test_that("Correct split votes", {
  x <- vote_history |>
    filter(!is.na(split_vote), !str_detect(split_vote, vote)) |>
    nrow()

  expect_equal(x, 0)
})

test_that("No votes for people who have immunity", {
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

test_that("Individual immunity assigned on vote history", {
  nobody_immune <- vote_history |>
    filter(tribe_status == "Merged") |>
    filter(vote_order == 1) |>
    group_by(version_season, version, season, episode, order) |>
    summarise(immunity_winner = sum(immunity == "Individual", na.rm = TRUE)) |>
    filter(immunity_winner == 0)

  expect_equal(nrow(nobody_immune), 4)
})

test_that("Winners on challenge_results match immunity on vote_history", {
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

  expect_equal(x1, 15)
})

# test_that("typos in tribe", {
#
# })
