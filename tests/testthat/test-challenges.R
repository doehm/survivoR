
library(dplyr)
library(purrr)
library(stringr)

context("Challenges")

test_that("No challenge without at least 1 descriptive feature", {

  x <- survivoR::challenge_description |>
    # dplyr::filter(challenge_id != "CHxxx") |>
    dplyr::filter(
      !puzzle,
      !race,
      !precision,
      !endurance,
      !strength,
      !turn_based,
      !balance,
      !food,
      !knowledge,
      !memory,
      !fire,
      !water
    ) |>
    nrow()

  expect_equal(x, 11)

})

