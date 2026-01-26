### [GENERATED AUTOMATICALLY] Update test-pull.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    pull(test_pl, mpg),
    pull(test, mpg)
  )

  expect_equal_lazy(
    pull(test_pl, "mpg"),
    pull(test, "mpg")
  )

  expect_equal_lazy(
    pull(test_pl, 1),
    pull(test, 1)
  )
})

test_that("error cases work", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_both_error(
    pull(test_pl, dplyr::all_of(c("mpg", "drat"))),
    pull(test, dplyr::all_of(c("mpg", "drat")))
  )
  expect_snapshot_lazy(
    pull(test_pl, dplyr::all_of(c("mpg", "drat"))),
    error = TRUE
  )

  # tidypolars-specific (dplyr::pull only takes one column argument)
  expect_snapshot_lazy(
    pull(test_pl, mpg, drat, hp),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
