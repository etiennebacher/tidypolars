### [GENERATED AUTOMATICALLY] Update test-pull.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    pull(test_pl, mpg),
    pull(test_df, mpg)
  )

  expect_equal_lazy(
    pull(test_pl, "mpg"),
    pull(test_df, "mpg")
  )

  expect_equal_lazy(
    pull(test_pl, 1),
    pull(test_df, 1)
  )
})

test_that("error cases work", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    pull(test_pl, all_of(c("mpg", "drat"))),
    pull(test_df, all_of(c("mpg", "drat")))
  )
  expect_snapshot_lazy(
    pull(test_pl, all_of(c("mpg", "drat"))),
    error = TRUE
  )
  expect_both_error(
    pull(test_pl, mpg, drat, hp),
    pull(test_df, mpg, drat, hp),
  )
  expect_snapshot_lazy(
    pull(test_pl, mpg, drat, hp),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
