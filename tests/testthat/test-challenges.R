
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
