test_that("basic behavior works", {
  test_df <- tibble(x = c(NA, 1), y = c(2L, NA_integer_))
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(replace_na(test_pl, list(x = 0)))

  expect_both_error(
    replace_na(test_pl, 0),
    replace_na(test_df, 0)
  )

  expect_equal(
    replace_na(test_pl, list(x = 0, y = 999)),
    replace_na(test_df, list(x = 0, y = 999))
  )

  expect_equal(
    test_pl |> mutate(x = replace_na(x, 0)),
    test_df |> mutate(x = replace_na(x, 0))
  )
})

test_that("error if original values and replacement have no supertype", {
  test_df <- tibble(x = c(NA, 1), y = c(2, NA))
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    replace_na(test_pl, list(x = "a")),
    replace_na(test_df, list(x = "a"))
  )
  expect_snapshot(
    replace_na(test_pl, list(x = "a")),
    error = TRUE
  )
  expect_both_error(
    replace_na(test_pl, list(x = 1, y = "unknown")),
    replace_na(test_df, list(x = 1, y = "unknown"))
  )
  expect_snapshot(
    replace_na(test_pl, list(x = 1, y = "unknown")),
    error = TRUE
  )
})

test_that("works if original values and replacement have a supertype", {
  test_df <- tibble(x = c(NA, 1), y = c(2L, NA_integer_))
  test_pl <- as_polars_df(test_df)

  # TODO: tidyr forbids replacing an int by a float
  # expect_equal(
  #   replace_na(test_pl, list(x = 0.1, y = 1.5)),
  #   replace_na(test_df, list(x = 0.1, y = 1.5))
  # )
})
