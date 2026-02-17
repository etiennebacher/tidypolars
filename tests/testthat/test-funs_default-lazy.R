### [GENERATED AUTOMATICALLY] Update test-funs_default.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("which.min() and which.max() work", {
  test_df <- tibble(
    x = c(1:4, 0:5, 11, 10),
    x_na = c(1:4, NA, 1:5, 11, 10),
    x_inf = c(1, Inf, 3:4, -Inf, 1:5, 11, 10)
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
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
  test_df <- tibble(
    x = c("a", "a", "a", "b", "b"),
    y = c(1:4, NA)
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> mutate(foo = length(y)),
    test_df |> mutate(foo = length(y))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = length(y), .by = x),
    test_df |> mutate(foo = length(y), .by = x)
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = length(y), .by = c(x, y)),
    test_df |> mutate(foo = length(y), .by = c(x, y))
  )
})

test_that("unique() works", {
  test_df <- tibble(
    x = c("a", "a", "a", "b", "b"),
    y = c(2, 2, 3, 4, NA)
  )
  test_pl <- as_polars_lf(test_df)

  # tidypolars-specific error (tidyverse allows unique() directly)
  expect_snapshot_lazy(
    test_pl |> mutate(foo = unique(y)),
    error = TRUE
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = length(unique(y))),
    test_df |> mutate(foo = length(unique(y)))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = length(unique(y)), .by = x),
    test_df |> mutate(foo = length(unique(y)), .by = x)
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = length(unique(y)), .by = c(x, y)),
    test_df |> mutate(foo = length(unique(y)), .by = c(x, y))
  )
})

test_that("rev() works", {
  test_df <- tibble(
    x = c("a", "a", "a", "b", "b"),
    y = c(2, 2, 3, 4, NA)
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> mutate(foo = rev(y)),
    test_df |> mutate(foo = rev(y))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = rev(x)),
    test_df |> mutate(foo = rev(x))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = rev(y), .by = x),
    test_df |> mutate(foo = rev(y), .by = x)
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = rev(y), .by = c(x, y)),
    test_df |> mutate(foo = rev(y), .by = c(x, y))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = rev(y + 1), .by = x),
    test_df |> mutate(foo = rev(y + 1), .by = x)
  )
})

test_that("all() works", {
  test_df <- tibble(x = c(TRUE, FALSE, NA), y = c(TRUE, TRUE, NA))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> mutate(foo = all(x)),
    test_df |> mutate(foo = all(x))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = all(y)),
    test_df |> mutate(foo = all(y))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = all(y, na.rm = TRUE)),
    test_df |> mutate(foo = all(y, na.rm = TRUE))
  )
})

test_that("any() works", {
  test_df <- tibble(
    x = c(FALSE, FALSE, NA),
    y = c(TRUE, TRUE, NA)
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> mutate(foo = any(x)),
    test_df |> mutate(foo = any(x))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = any(x, na.rm = TRUE)),
    test_df |> mutate(foo = any(x, na.rm = TRUE))
  )
})

test_that("round() works", {
  test_df <- tibble(x = c(0.33, 0.5212))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> mutate(foo = round(x)),
    test_df |> mutate(foo = round(x))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = round(x, 1)),
    test_df |> mutate(foo = round(x, 1))
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = round(x, 3)),
    test_df |> mutate(foo = round(x, 3))
  )
})

test_that("stats::lag() is not supported", {
  test_df <- tibble(x = c(10, 20, 30, 40, 10, 20, 30, 40))
  test_pl <- as_polars_lf(test_df)
  expect_error_lazy(
    test_pl |> mutate(x_lag = stats::lag(x)),
    "doesn't know how to translate this function: `stats::lag()`",
    fixed = TRUE
  )
})

test_that("seq() works", {
  test_df <- tibble(x = 1:4)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test_pl, y = seq(2, 5)),
    mutate(test_df, y = seq(2, 5))
  )
  expect_equal_lazy(
    mutate(test_pl, y = seq(1, 2, 4)),
    mutate(test_df, y = seq(1, 2, 4))
  )

  test_df <- tibble(x = 1:2)
  test_pl <- as_polars_lf(test_df)
  expect_equal_lazy(
    mutate(test_pl, y = seq(1, 4, by = 2)),
    mutate(test_df, y = seq(1, 4, by = 2))
  )

  expect_error_lazy(
    expect_warning(
      mutate(test_pl, y = seq(1, 4, length.out = 2)),
      "doesn't know how to"
    )
  )
})

test_that("seq_len() works", {
  test_df <- tibble(x = 1:4)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test_pl, y = seq_len(4)),
    mutate(test_df, y = seq_len(4))
  )
  expect_equal_lazy(
    mutate(test_pl, y = seq_len(1)),
    mutate(test_df, y = seq_len(1))
  )
  expect_both_error(
    mutate(test_pl, y = seq_len(-1)),
    mutate(test_df, y = seq_len(-1))
  )
  expect_snapshot_lazy(
    mutate(test_pl, y = seq_len(-1)),
    error = TRUE
  )
})

test_that("anyNA() works", {
  test_df <- tibble(x = 1:4, y = c(1:3, NA))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test_pl, y = anyNA(x)),
    mutate(test_df, y = anyNA(x))
  )
  expect_equal_lazy(
    mutate(test_pl, y = anyNA(y)),
    mutate(test_df, y = anyNA(y))
  )

  expect_snapshot_lazy(
    mutate(test_pl, y = anyNA(x, recursive = TRUE)),
    error = TRUE
  )
})

test_that("is.finite, is.infinite, is.nan", {
  test_df <- tibble(x = c(-Inf, 1, NA, NaN, Inf))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test_pl, y = is.infinite(x)),
    mutate(test_df, y = is.infinite(x))
  )
  expect_equal_lazy(
    mutate(test_pl, y = is.finite(x)),
    mutate(test_df, y = is.finite(x))
  )
  expect_equal_lazy(
    mutate(test_pl, y = is.nan(x)),
    mutate(test_df, y = is.nan(x))
  )
})

test_that("is.na", {
  # This test doesn't have NaN (see note in pl_is.na())
  test_df <- tibble(x = c(-Inf, 1, NA, Inf))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test_pl, y = is.na(x)),
    mutate(test_df, y = is.na(x))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
