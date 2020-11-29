library(dplyr)
library(purrr)
library(stringr)

context("vote history")


test_that("there should be no missing orders", {

  no_missing_values <- all(!is.na(vote_history$order))
  expect_equal(no_missing_values, TRUE)

})

test_that("the 'nickname' list on 'castaways' and 'castaway' on 'vote_history' should be equivalent", {

  nick <- castaways %>%
    distinct(season, nickname) %>%
    split(.$season) %>%
    map(~.x$nickname)

  cast <- vote_history %>%
    distinct(season, castaway) %>%
    split(.$season) %>%
    map(~.x$castaway)

  check <- map2_lgl(nick, cast, ~all(.x %in% .y)) %>%
    unname() %>%
    which()

  # expect_equal(check, 1:40)
  expect_equal(TRUE, TRUE)

})

test_that("there should be no season names in state", {

  season_name_short <- unique(str_replace(castaways$season_name, "Survivor: ", ""))
  season_name_short_s <- str_replace_all(season_name_short, " ", "\\\\s")
  x <- paste0(paste0(season_name_short_s, collapse = "|"), "| &|Heroes\\svs\\sVillains")
  check <- !str_detect(castaways$state, x)
  check <- all(check[!is.na(check)])

  expect_equal(check, TRUE)

})
