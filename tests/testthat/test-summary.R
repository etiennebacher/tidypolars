test_that("basic behavior works", {
  test <- as_polars_df(mtcars)

  expect_is_tidypolars(summary(test))

  expect_equal(
    summary(test) |>
      pull(statistic),
    c("count", "null_count", "mean", "std", "min", "25%", "50%", "75%", "max")
  )

  expect_equal(
    summary(test, percentiles = c(0.2, 0.4)) |>
      pull(statistic),
    c("count", "null_count", "mean", "std", "min", "20%", "40%", "50%", "max")
  )

  expect_equal(
    summary(test, percentiles = c(0.2, 0.4, NULL)) |>
      pull(statistic),
    c("count", "null_count", "mean", "std", "min", "20%", "40%", "50%", "max")
  )
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
