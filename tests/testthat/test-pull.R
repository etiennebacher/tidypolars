test_that("basic behavior works", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_equal(
    pull(test_pl, mpg),
    pull(test, mpg)
  )

  expect_equal(
    pull(test_pl, "mpg"),
    pull(test, "mpg")
  )

  expect_equal(
    pull(test_pl, 1),
    pull(test, 1)
  )
})

test_that("error cases work", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_both_error(
    pull(test_pl, dplyr::all_of(c("mpg", "drat"))),
    pull(test, dplyr::all_of(c("mpg", "drat")))
  )
  expect_snapshot(
    pull(test_pl, dplyr::all_of(c("mpg", "drat"))),
    error = TRUE
  )

  # tidypolars-specific (dplyr::pull only takes one column argument)
  expect_snapshot(
    pull(test_pl, mpg, drat, hp),
    error = TRUE
  )
})
