test_that("basic behavior works", {
  test <- as_polars_df(mtcars)

  expect_is_tidypolars(summary(test))

  expect_snapshot(summary(test))
  expect_snapshot(summary(test, percentiles = c(0.2, 0.4)))
  expect_snapshot(summary(test, percentiles = c(0.2, 0.4, NULL)))
})

test_that("check percentiles", {
  test <- as_polars_df(mtcars)
  expect_snapshot(
    summary(test, percentiles = c(0.2, 0.4, NA)),
    error = TRUE
  )
  expect_snapshot(
    summary(test, percentiles = -1),
    error = TRUE
  )
})
