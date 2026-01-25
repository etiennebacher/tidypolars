### [GENERATED AUTOMATICALLY] Update test-funs_default.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("which.min() and which.max() work", {
  test_df <- tibble(
    x = c(1:4, 0:5, 11, 10),
    x_na = c(1:4, NA, 1:5, 11, 10),
    x_inf = c(1, Inf, 3:4, -Inf, 1:5, 11, 10)
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    test |>
      mutate(
        argmin = which.min(x),
        argmax = which.max(x),
        argmin_na = which.min(x_na),
        argmax_na = which.max(x_na),
        argmin_inf = which.min(x_inf),
        argmax_inf = which.max(x_inf)
      ),
    test_df |>
      mutate(
        argmin = which.min(x),
        argmax = which.max(x),
        argmin_na = which.min(x_na),
        argmax_na = which.max(x_na),
        argmin_inf = which.min(x_inf),
        argmax_inf = which.max(x_inf)
      )
  )
})

test_that("length() works", {
  test <- polars::pl$LazyFrame(
    x = c("a", "a", "a", "b", "b"),
    y = c(1:4, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(y)) |>
      pull(foo),
    rep(5, 5)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(y), .by = x) |>
      pull(foo),
    c(3, 3, 3, 2, 2)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(y), .by = c(x, y)) |>
      pull(foo),
    rep(1, 5)
  )
})

test_that("unique() works", {
  test <- polars::pl$LazyFrame(
    x = c("a", "a", "a", "b", "b"),
    y = c(2, 2, 3, 4, NA)
  )

  expect_snapshot_lazy(
    test |> mutate(foo = unique(y)),
    error = TRUE
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(unique(y))) |>
      pull(foo),
    rep(4, 5)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(unique(y)), .by = x) |>
      pull(foo),
    rep(2, 5)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(unique(y)), .by = c(x, y)) |>
      pull(foo),
    rep(1, 5)
  )
})

test_that("rev() works", {
  test <- polars::pl$LazyFrame(
    x = c("a", "a", "a", "b", "b"),
    y = c(2, 2, 3, 4, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(y)) |>
      pull(foo),
    c(NA, 4, 3, 2, 2)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(x)) |>
      pull(foo),
    c("b", "b", "a", "a", "a")
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(y), .by = x) |>
      pull(foo),
    c(3, 2, 2, NA, 4)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(y), .by = c(x, y)) |>
      pull(foo),
    c(2, 2, 3, 4, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(y + 1), .by = x) |>
      pull(foo),
    c(4, 3, 3, NA, 5)
  )
})

test_that("all() works", {
  test <- polars::pl$LazyFrame(x = c(TRUE, FALSE, NA), y = c(TRUE, TRUE, NA))

  expect_equal_lazy(
    test |>
      mutate(foo = all(x)) |>
      pull(foo),
    # we know it's FALSE because there's one FALSE in x, so the na.rm arg is irrelevant
    c(FALSE, FALSE, FALSE)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = all(y)) |>
      pull(foo),
    c(NA, NA, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = all(y, na.rm = TRUE)) |>
      pull(foo),
    c(TRUE, TRUE, TRUE)
  )
})

test_that("any() works", {
  test <- polars::pl$LazyFrame(
    x = c(FALSE, FALSE, NA),
    y = c(TRUE, TRUE, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = any(x)) |>
      pull(foo),
    c(NA, NA, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = any(x, na.rm = TRUE)) |>
      pull(foo),
    c(FALSE, FALSE, FALSE)
  )
})

test_that("round() works", {
  test <- polars::pl$LazyFrame(x = c(0.33, 0.5212))

  expect_equal_lazy(
    test |>
      mutate(foo = round(x)) |>
      pull(foo),
    c(0, 1)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = round(x, 1)) |>
      pull(foo),
    c(0.3, 0.5)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = round(x, 3)) |>
      pull(foo),
    c(0.33, 0.521)
  )
})

test_that("stats::lag() is not supported", {
  dat <- pl$LazyFrame(x = c(10, 20, 30, 40, 10, 20, 30, 40))
  expect_error_lazy(
    dat |> mutate(x_lag = stats::lag(x)),
    "doesn't know how to translate this function: `stats::lag()`",
    fixed = TRUE
  )
})

test_that("seq() works", {
  dat <- tibble(x = 1:4)
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq(2, 5)),
    mutate(dat, y = seq(2, 5))
  )
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq(1, 2, 4)),
    mutate(dat, y = seq(1, 2, 4))
  )

  dat <- tibble(x = 1:2)
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq(1, 4, by = 2)),
    mutate(dat, y = seq(1, 4, by = 2))
  )

  expect_error_lazy(
    expect_warning(
      mutate(as_polars_lf(dat), y = seq(1, 4, length.out = 2)),
      "doesn't know how to"
    )
  )
})

test_that("seq_len() works", {
  dat <- tibble(x = 1:4)
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq_len(4)),
    mutate(dat, y = seq_len(4))
  )
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq_len(1)),
    mutate(dat, y = seq_len(1))
  )
  expect_error_lazy(
    mutate(as_polars_lf(dat), y = seq_len(-1)),
    "must be a non-negative integer"
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
