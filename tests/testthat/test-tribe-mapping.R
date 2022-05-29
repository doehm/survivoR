
test_that("No NAs in castaway_ids (tribe mapping)", {

  x <- survivoR::tribe_mapping

  expect_equal(all(!is.na(x$castaway_id)), TRUE)

})
