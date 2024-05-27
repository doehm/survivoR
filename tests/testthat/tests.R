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
    summarise(immunity_winner = sum(immunity %in% c("Individual", "Earned merge"), na.rm = TRUE)) |>
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

  expect_equal(x1, 14)
})

test_that("Jury votes matches 'jury' on castaways", {

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

test_that("Challenge summary and challenge results are the same size", {
  x1 <- challenge_summary |>
    distinct(version_season, challenge_id) |>
    nrow()

  x2 <- challenge_results |>
    filter(version == "US") |>
    distinct(version_season, challenge_id) |>
    nrow()

  expect_equal(x1, x2)
})


test_that("More than one winner", {
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


test_that("Jury count the same on castaways and jury votes", {

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
