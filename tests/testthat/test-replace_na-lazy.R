### [GENERATED AUTOMATICALLY] Update test-replace_na.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- tibble(x = c(NA, 1), y = c(2L, NA_integer_))
  test_pl <- as_polars_lf(test)

  expect_is_tidypolars(replace_na(test_pl, list(x = 0)))

  expect_both_error(
    replace_na(test_pl, 0),
    replace_na(test, 0)
  )

  expect_equal_lazy(
    replace_na(test_pl, list(x = 0, y = 999)),
    replace_na(test, list(x = 0, y = 999))
  )

  expect_equal_lazy(
    test_pl |> mutate(x = replace_na(x, 0)),
    test |> mutate(x = replace_na(x, 0))
  )
})

test_that("error if original values and replacement have no supertype", {
  test <- tibble(x = c(NA, 1), y = c(2, NA))
  test_pl <- as_polars_lf(test)

  expect_both_error(
    replace_na(test_pl, list(x = "a")),
    replace_na(test, list(x = "a"))
  )
  expect_snapshot_lazy(
    replace_na(test_pl, list(x = "a")),
    error = TRUE
  )
  expect_both_error(
    replace_na(test_pl, list(x = 1, y = "unknown")),
    replace_na(test, list(x = 1, y = "unknown"))
  )
  expect_snapshot_lazy(
    replace_na(test_pl, list(x = 1, y = "unknown")),
    error = TRUE
  )
})

test_that("works if original values and replacement have a supertype", {
  test <- tibble(x = c(NA, 1), y = c(2L, NA_integer_))
  test_pl <- as_polars_lf(test)

  # TODO: tidyr forbids replacing an int by a float
  # expect_equal_lazy(
  #   replace_na(test_pl, list(x = 0.1, y = 1.5)),
  #   replace_na(test, list(x = 0.1, y = 1.5))
  # )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
