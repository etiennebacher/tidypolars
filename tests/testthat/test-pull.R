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

  expect_equal(
    pull(test_pl, -1),
    pull(test_df, -1)
  )

  expect_equal(
    pull(test_pl, -2),
    pull(test_df, -2)
  )

  expect_equal(
    pull(test_pl),
    pull(test_df)
  )
})

test_that("name can be used to name the pulled vector", {
  test_df <- tibble(
    id = c("a", "b", "a"),
    value = c(10, 20, 30),
    other = c(TRUE, FALSE, TRUE)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    pull(test_pl, value, name = id),
    pull(test_df, value, name = id)
  )

  expect_equal(
    pull(test_pl, -1, name = 1),
    pull(test_df, -1, name = 1)
  )

  expect_equal(
    pull(test_pl, value, name = value),
    pull(test_df, value, name = value)
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
    pull(test_df, mpg, drat, hp)
  )
  expect_snapshot(
    pull(test_pl, mpg, drat, hp),
    error = TRUE
  )
})
