### [GENERATED AUTOMATICALLY] Update test-replace_na.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  pl_test <- polars0::pl$LazyFrame(x = c(NA, 1), y = c(2L, NA_integer_))

  expect_is_tidypolars(replace_na(pl_test, 0))

  expect_equal_lazy(
    replace_na(pl_test, 0),
    data.frame(x = c(0, 1), y = c(2, 0))
  )

  expect_equal_lazy(
    replace_na(pl_test, list(x = 0, y = 999)),
    data.frame(x = c(0, 1), y = c(2, 999))
  )

  expect_equal_lazy(
    pl_test |>
      mutate(x = replace_na(x, 0)),
    data.frame(x = c(0, 1), y = c(2, NA))
  )
})

test_that("error if original values and replacement have no supertype", {
  pl_test <- polars0::pl$LazyFrame(x = c(NA, 1), y = c(2, NA))
  expect_snapshot_lazy(
    replace_na(pl_test, "a"),
    error = TRUE
  )
  expect_snapshot_lazy(
    replace_na(pl_test, list(x = 1, y = "unknown")),
    error = TRUE
  )
})

test_that("works if original values and replacement have a supertype", {
  pl_test <- polars0::pl$LazyFrame(x = c(NA, 1), y = c(2L, NA_integer_))

  expect_equal_lazy(
    replace_na(pl_test, 1.5),
    data.frame(x = c(1.5, 1), y = c(2, 1.5))
  )

  expect_equal_lazy(
    replace_na(pl_test, list(x = 0.1, y = 1.5)),
    data.frame(x = c(0.1, 1), y = c(2, 1.5))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
