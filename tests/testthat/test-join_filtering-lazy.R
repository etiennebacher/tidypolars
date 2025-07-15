### [GENERATED AUTOMATICALLY] Update test-join_filtering.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior with common column names", {
  test <- polars::pl$LazyFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$LazyFrame(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_is_tidypolars(semi_join(test, test2, join_by(x, y)))
  expect_is_tidypolars(anti_join(test, test2, join_by(x, y)))

  expect_equal_lazy(
    semi_join(test, test2, by = c("x", "y")),
    pl$LazyFrame(
      x = c(1, 2),
      y = c(1, 2),
      z = c(1, 2)
    )
  )

  expect_equal_lazy(
    anti_join(test, test2, by = c("x", "y")),
    pl$LazyFrame(
      x = 3,
      y = 3,
      z = 3
    )
  )
})

test_that("basic behavior with different column names", {
  test <- polars::pl$LazyFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$LazyFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_equal_lazy(
    semi_join(test, test2, by = c("x", "y1" = "y2")),
    pl$LazyFrame(
      x = c(1, 2),
      y1 = c(1, 2),
      z = c(1, 2)
    )
  )

  expect_equal_lazy(
    anti_join(test, test2, by = c("x", "y1" = "y2")),
    pl$LazyFrame(
      x = 3,
      y1 = 3,
      z = 3
    )
  )
})

test_that("join_by() with strict equality", {
  test <- polars::pl$LazyFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$LazyFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_equal_lazy(
    semi_join(test, test2, by = join_by(x, y1 == y2)),
    pl$LazyFrame(
      x = c(1, 2),
      y1 = c(1, 2),
      z = c(1, 2)
    )
  )

  expect_equal_lazy(
    anti_join(test, test2, by = join_by(x, y1 == y2)),
    pl$LazyFrame(
      x = 3,
      y1 = 3,
      z = 3
    )
  )
})

test_that("join_by() doesn't work with inequality", {
  test <- polars::pl$LazyFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$LazyFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_snapshot_lazy(
    semi_join(test, test2, by = join_by(x, y1 > y2)),
    error = TRUE
  )
  expect_snapshot_lazy(
    anti_join(test, test2, by = join_by(x, y1 > y2)),
    error = TRUE
  )
})

test_that("fallback on dplyr error if wrong join_by specification", {
  test <- polars::pl$LazyFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$LazyFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )
  expect_snapshot_lazy(
    semi_join(test, test2, by = join_by(x, y1 = y2)),
    error = TRUE
  )
  expect_snapshot_lazy(
    anti_join(test, test2, by = join_by(x, y1 = y2)),
    error = TRUE
  )
})

test_that("argument na_matches works", {
  pdf1 <- pl$LazyFrame(a = c(1, NA, NA, NaN), val = 1:4)
  pdf2 <- pl$LazyFrame(a = c(1, 2, NA, NaN), val2 = 5:8)

  expect_equal_lazy(
    semi_join(pdf1, pdf2, "a") |>
      pull(a),
    c(1, NA, NA, NaN)
  )

  expect_equal_lazy(
    semi_join(pdf1, pdf2, "a", na_matches = "never") |>
      pull(a),
    c(1, NaN)
  )
})

test_that("unsupported args throw warning", {
  test <- polars::pl$LazyFrame(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- polars::pl$LazyFrame(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  expect_warning(
    semi_join(test, test2, copy = TRUE),
    "Argument `copy` is not supported by tidypolars"
  )
  withr::with_options(
    list(tidypolars_unknown_args = "error"),
    expect_snapshot_lazy(
      semi_join(test, test2, copy = TRUE),
      error = TRUE
    )
  )
})

test_that("dots must be empty", {
  test <- polars::pl$LazyFrame(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- polars::pl$LazyFrame(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  expect_snapshot_lazy(
    semi_join(test, test2, foo = TRUE),
    error = TRUE
  )
  expect_snapshot_lazy(
    semi_join(test, test2, copy = TRUE, foo = TRUE),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
