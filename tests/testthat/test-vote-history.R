context("vote history")


test_that("there should be no missing orders", {

  cond <- all(!is.na(vote_history$order))
  expect_equal(cond, TRUE)

})
