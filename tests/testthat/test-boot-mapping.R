library(dplyr)
library(purrr)
library(stringr)

context("Boot mapping")

test_that("No NAs in castaway_ids (boot mapping)", {

  x <- survivoR::boot_mapping

  expect_equal(all(!is.na(x$castaway_id)), TRUE)

})
