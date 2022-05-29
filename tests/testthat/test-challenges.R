
test_that("No challenge without at least 1 descriptive feature", {

  x <- challenge_description |>
    filter(
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


test_that("No NAs in castaway_ids", {

  x <- survivoR::challenge_results |>
    filter(challenge_name != "Survivor Auction") |>
    unnest(winners)

  expect_equal(all(!is.na(x$winner_id)), TRUE)

})

test_that("No NAs in challenge_ids (Challenge Results)", {

  x <- survivoR::challenge_results |>
    filter(challenge_name != "Survivor Auction")

  expect_equal(all(!is.na(x$challenge_id)), TRUE)

})
