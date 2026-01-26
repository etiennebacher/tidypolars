test_that("basic behavior works", {
  # tidypolars-specific (summary() for polars DataFrames is different from base R)
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_is_tidypolars(summary(test_pl))

  expect_snapshot(summary(test_pl))
  expect_snapshot(summary(test_pl, percentiles = c(0.2, 0.4)))
  expect_snapshot(summary(test_pl, percentiles = c(0.2, 0.4, NULL)))
})

test_that("check percentiles", {
  # tidypolars-specific errors
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_snapshot(
    summary(test_pl, percentiles = c(0.2, 0.4, NA)),
    error = TRUE
  )
  expect_snapshot(
    summary(test_pl, percentiles = -1),
    error = TRUE
  )
})
