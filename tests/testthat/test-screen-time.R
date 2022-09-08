library(dplyr)
library(purrr)
library(stringr)

context("Screen time")

test_that("there should be screen time for each contestant in the season", {
  seasons <- screen_time |>
    distinct(version_season) |>
    pull(version_season)

  walk(seasons, function(ssn) {
    n_contestants <- screen_time |>
      filter(version_season == ssn,
             !(castaway_id %in% c('host', 'unknown'))) |>
      distinct(version_season, castaway_id) |>
      nrow()

    n_check <- castaways |>
      filter(version_season == ssn) |>
      nrow()

    expect_equal(n_contestants, n_check)
  })
})

test_that("No NAs in any columns", {
  walk(screen_time, function(col) {
    expect_equal(all(!is.na(col)), TRUE)
  })
})

