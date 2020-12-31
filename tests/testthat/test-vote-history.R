library(dplyr)
library(purrr)
library(stringr)

context("vote history")

test_that("there should be no missing orders", {

  # vote_history %>%
  #   filter(is.na(order)) %>%
  #   View("missing order")

  no_missing_values <- all(!is.na(vote_history$order))
  expect_equal(no_missing_values, TRUE)

})

test_that("there should be no season names in state", {

  season_name_short <- unique(str_replace(castaways$season_name, "Survivor: ", ""))
  season_name_short_s <- str_replace_all(season_name_short, " ", "\\\\s")
  x <- paste0(paste0(season_name_short_s, collapse = "|"), "| &|Heroes\\svs\\sVillains")
  check <- !str_detect(castaways$state, x)
  check <- all(check[!is.na(check)])

  expect_equal(check, TRUE)

})

test_that("no brother / mother / sister / whatever in the blood vs water seasons", {

  x <- "brother|sister|husband|wife|fianc|daughter|son|niece"
  states <- castaways$state[!is.na(castaways$state)]
  check <- all(!str_detect(states, x))
  expect_equal(check, TRUE)

})

test_that("no square brackets", {

  check <- all(!str_detect(vote_history$vote, "\\[|\\]"))
  expect_equal(check, TRUE)

})

test_that("castaways order goes from 1:n()", {

  check <- castaways %>%
    group_by(season) %>%
    summarise(
      n = n(),
      max_order = max(order)
    ) %>%
    mutate(check = n == max_order) %>%
    .$check

  expect_equal(all(check), TRUE)

})

test_that("jury votes match the outcome", {

  match <- jury_votes %>%
    group_by(season, finalist) %>%
    summarise(n = sum(vote)) %>%
    group_by(season) %>%
    filter(n == max(n)) %>%
    left_join(
      season_summary %>%
        select(season, winner),
      by = "season"
    ) %>%
    mutate(match = finalist == winner) %>%
    .$match

  expect_equal(all(match), TRUE)

})

test_that("every castaway has an original tribe", {

  match <- all(!is.na(castaways$original_tribe))
  expect_equal(match, TRUE)

})
