
library(dplyr)

in_progress_seasons <- c("US51")

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

  n_winners <- season_summary |>
    filter(!version_season %in% in_progress_seasons) |>
    filter(version_season != "SA05") |>
    nrow()

  confessionals |>
    add_winner() |>
    filter(version_season != "SA05") |>
    filter(!version_season %in% in_progress_seasons) |>
    distinct(version_season, castaway, winner) |>
    summarise(winner = sum(winner)) |>
    pull(winner) |>
    expect_equal(n_winners)

})


test_that("add_jury works", {

  n_jury <- season_summary |>
    filter(!version_season %in% in_progress_seasons) |>
    filter(version_season != "SA05") |>
    summarise(
      n_jury = sum(n_jury)
    ) |>
    pull(n_jury)

  confessionals |>
    add_jury() |>
    filter(version_season != "SA05") |>
    filter(!version_season %in% in_progress_seasons) |>
    distinct(version_season, castaway, jury) |>
    summarise(jury = sum(jury)) |>
    pull(jury) |>
    expect_equal(n_jury)

})


test_that("add_finalist works", {

  n_finalists <- season_summary |>
    filter(!version_season %in% in_progress_seasons) |>
    filter(version_season != "SA05") |>
    summarise(
      n_finalists = sum(n_finalists)
    ) |>
    pull(n_finalists)

  confessionals |>
    add_finalist() |>
    filter(version_season != "SA05") |>
    filter(!version_season %in% in_progress_seasons) |>
    distinct(version_season, castaway, finalist) |>
    summarise(finalist = sum(finalist)) |>
    pull(finalist) |>
    expect_equal(n_finalists)

})


test_that("add_castaway works", {

  df <- confessionals |>
    filter_us(47) |>
    group_by(castaway_id) |>
    summarise(n = sum(confessional_count)) |>
    add_castaway()

  expect_equal("castaway" %in% colnames(df) & all(!is.na(df$castaway)), TRUE)

})
