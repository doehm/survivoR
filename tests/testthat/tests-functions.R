
library(dplyr)

in_progress_seasons <- c("US49", "US50")

test_that("add_alive works", {

  df <- confessionals |>
    filter_us(47) |>
    add_alive(12)

  df |>
    filter(alive) |>
    group_by(castaway) |>
    summarise(n = sum(confessional_count)) |>
    nrow() |>
    expect_equal(6)

})


test_that("add_winner works", {

  confessionals |>
    add_winner() |>
    filter(version_season != "SA05") |>
    filter(!version_season %in% in_progress_seasons) |>
    distinct(version_season, castaway, winner) |>
    summarise(winner = sum(winner)) |>
    pull(winner) |>
    expect_equal(72)

})


test_that("add_jury works", {

  confessionals |>
    add_jury() |>
    filter(version_season != "SA05") |>
    filter(!version_season %in% in_progress_seasons) |>
    distinct(version_season, castaway, jury) |>
    summarise(jury = sum(jury)) |>
    pull(jury) |>
    expect_equal(597)

})


test_that("add_finalist works", {

  confessionals |>
    add_finalist() |>
    filter(version_season != "SA05") |>
    filter(!version_season %in% in_progress_seasons) |>
    distinct(version_season, castaway, finalist) |>
    summarise(finalist = sum(finalist)) |>
    pull(finalist) |>
    expect_equal(184)

})


test_that("add_castaway works", {

  df <- confessionals |>
    filter_us(47) |>
    group_by(castaway_id) |>
    summarise(n = sum(confessional_count)) |>
    add_castaway()

  expect_equal("castaway" %in% colnames(df) & all(!is.na(df$castaway)), TRUE)

})
