library(dplyr)
library(purrr)
library(stringr)

context("castaways")

test_that("There are no NAs in age", {

  expect_equal(all(!is.na(castaways$age)), TRUE)

})

test_that("There are no NAs in city", {

  expect_equal(all(!is.na(castaways$city)), TRUE)

})

test_that("There are no NAs in state", {

  expect_equal(all(!is.na(castaways$state)), TRUE)

})
