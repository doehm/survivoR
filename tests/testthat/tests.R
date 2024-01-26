library(dplyr)

test_that("no one voted for themself", {
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
