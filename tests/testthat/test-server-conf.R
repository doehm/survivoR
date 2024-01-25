library(dplyr)

test_that("no one voted for themself", {
  x <- vote_history |>
    filter(castaway == vote)

  expect_equal(nrow(x), 0)
})
