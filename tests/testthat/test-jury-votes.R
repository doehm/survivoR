

test_that("No NAs in finalist_ids (jury votes)", {

  expect_equal(all(!is.na(survivoR::jury_votes$finalist_id)), TRUE)

})

test_that("No NAs in castaway_ids (jury votes)", {

  expect_equal(all(!is.na(survivoR::jury_votes$castaway_id)), TRUE)

})


