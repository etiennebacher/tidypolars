test_that("basic behavior works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    pull(test_pl, mpg),
    pull(test_df, mpg)
  )

  expect_equal(
    pull(test_pl, "mpg"),
    pull(test_df, "mpg")
  )

  expect_equal(
    pull(test_pl, 1),
    pull(test_df, 1)
  )
})

test_that("error cases work", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    pull(test_pl, all_of(c("mpg", "drat"))),
    pull(test_df, all_of(c("mpg", "drat")))
  )
  expect_snapshot(
    pull(test_pl, all_of(c("mpg", "drat"))),
    error = TRUE
  )
  expect_both_error(
    pull(test_pl, mpg, drat, hp),
    pull(test_df, mpg, drat, hp),
  )
  expect_snapshot(
    pull(test_pl, mpg, drat, hp),
    error = TRUE
  )
})
