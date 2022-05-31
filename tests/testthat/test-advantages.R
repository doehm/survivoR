library(dplyr)
library(purrr)
library(stringr)

context("Advantages")

test_that("All advantages on details are on movement", {

  x <- survivoR::advantage_details |>
    anti_join(survivoR::advantage_movement, by = "advantage_id") |>
    nrow()

  expect_equal(x, 0)

})

test_that("All advantages on movement are on details", {

  x <- survivoR::advantage_movement |>
    anti_join(survivoR::advantage_details, by = "advantage_id") |>
    nrow()

  expect_equal(x, 0)

})
