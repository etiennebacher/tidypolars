test_that("which.min() and which.max() work", {
  test <- tibble(
    x = c(1:4, 0:5, 11, 10),
    x_na = c(1:4, NA, 1:5, 11, 10),
    x_inf = c(1, Inf, 3:4, -Inf, 1:5, 11, 10)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |>
      mutate(
        argmin = which.min(x),
        argmax = which.max(x),
        argmin_na = which.min(x_na),
        argmax_na = which.max(x_na),
        argmin_inf = which.min(x_inf),
        argmax_inf = which.max(x_inf)
      ),
    test |>
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
  test <- tibble(
    x = c("a", "a", "a", "b", "b"),
    y = c(1:4, NA)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = length(y)),
    test |> mutate(foo = length(y))
  )

  expect_equal(
    test_pl |> mutate(foo = length(y), .by = x),
    test |> mutate(foo = length(y), .by = x)
  )

  expect_equal(
    test_pl |> mutate(foo = length(y), .by = c(x, y)),
    test |> mutate(foo = length(y), .by = c(x, y))
  )
})

test_that("unique() works", {
  test <- tibble(
    x = c("a", "a", "a", "b", "b"),
    y = c(2, 2, 3, 4, NA)
  )
  test_pl <- as_polars_df(test)

  # tidypolars-specific error (tidyverse allows unique() directly)
  expect_snapshot(
    test_pl |> mutate(foo = unique(y)),
    error = TRUE
  )

  expect_equal(
    test_pl |> mutate(foo = length(unique(y))),
    test |> mutate(foo = length(unique(y)))
  )

  expect_equal(
    test_pl |> mutate(foo = length(unique(y)), .by = x),
    test |> mutate(foo = length(unique(y)), .by = x)
  )

  expect_equal(
    test_pl |> mutate(foo = length(unique(y)), .by = c(x, y)),
    test |> mutate(foo = length(unique(y)), .by = c(x, y))
  )
})

test_that("rev() works", {
  test <- tibble(
    x = c("a", "a", "a", "b", "b"),
    y = c(2, 2, 3, 4, NA)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = rev(y)),
    test |> mutate(foo = rev(y))
  )

  expect_equal(
    test_pl |> mutate(foo = rev(x)),
    test |> mutate(foo = rev(x))
  )

  expect_equal(
    test_pl |> mutate(foo = rev(y), .by = x),
    test |> mutate(foo = rev(y), .by = x)
  )

  expect_equal(
    test_pl |> mutate(foo = rev(y), .by = c(x, y)),
    test |> mutate(foo = rev(y), .by = c(x, y))
  )

  expect_equal(
    test_pl |> mutate(foo = rev(y + 1), .by = x),
    test |> mutate(foo = rev(y + 1), .by = x)
  )
})

test_that("all() works", {
  test <- tibble(x = c(TRUE, FALSE, NA), y = c(TRUE, TRUE, NA))
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = all(x)),
    test |> mutate(foo = all(x))
  )

  expect_equal(
    test_pl |> mutate(foo = all(y)),
    test |> mutate(foo = all(y))
  )

  expect_equal(
    test_pl |> mutate(foo = all(y, na.rm = TRUE)),
    test |> mutate(foo = all(y, na.rm = TRUE))
  )
})

test_that("any() works", {
  test <- tibble(
    x = c(FALSE, FALSE, NA),
    y = c(TRUE, TRUE, NA)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = any(x)),
    test |> mutate(foo = any(x))
  )

  expect_equal(
    test_pl |> mutate(foo = any(x, na.rm = TRUE)),
    test |> mutate(foo = any(x, na.rm = TRUE))
  )
})

test_that("round() works", {
  test <- tibble(x = c(0.33, 0.5212))
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = round(x)),
    test |> mutate(foo = round(x))
  )

  expect_equal(
    test_pl |> mutate(foo = round(x, 1)),
    test |> mutate(foo = round(x, 1))
  )

  expect_equal(
    test_pl |> mutate(foo = round(x, 3)),
    test |> mutate(foo = round(x, 3))
  )
})

test_that("stats::lag() is not supported", {
  test <- tibble(x = c(10, 20, 30, 40, 10, 20, 30, 40))
  test_pl <- as_polars_df(test)
  expect_error(
    test_pl |> mutate(x_lag = stats::lag(x)),
    "doesn't know how to translate this function: `stats::lag()`",
    fixed = TRUE
  )
})

test_that("seq() works", {
  test <- tibble(x = 1:4)
  test_pl <- as_polars_df(test)

  expect_equal(
    mutate(test_pl, y = seq(2, 5)),
    mutate(test, y = seq(2, 5))
  )
  expect_equal(
    mutate(test_pl, y = seq(1, 2, 4)),
    mutate(test, y = seq(1, 2, 4))
  )

  test <- tibble(x = 1:2)
  test_pl <- as_polars_df(test)
  expect_equal(
    mutate(test_pl, y = seq(1, 4, by = 2)),
    mutate(test, y = seq(1, 4, by = 2))
  )

  expect_error(
    expect_warning(
      mutate(test_pl, y = seq(1, 4, length.out = 2)),
      "doesn't know how to"
    )
  )
})

test_that("seq_len() works", {
  test <- tibble(x = 1:4)
  test_pl <- as_polars_df(test)

  expect_equal(
    mutate(test_pl, y = seq_len(4)),
    mutate(test, y = seq_len(4))
  )
  expect_equal(
    mutate(test_pl, y = seq_len(1)),
    mutate(test, y = seq_len(1))
  )
  expect_both_error(
    mutate(test_pl, y = seq_len(-1)),
    mutate(test, y = seq_len(-1))
  )
  expect_snapshot(
    mutate(test_pl, y = seq_len(-1)),
    error = TRUE
  )
})

test_that("anyNA() works", {
  test <- tibble(x = 1:4, y = c(1:3, NA))
  test_pl <- as_polars_df(test)

  expect_equal(
    mutate(test_pl, y = anyNA(x)),
    mutate(test, y = anyNA(x))
  )
  expect_equal(
    mutate(test_pl, y = anyNA(y)),
    mutate(test, y = anyNA(y))
  )

  expect_snapshot(
    mutate(test_pl, y = anyNA(x, recursive = TRUE)),
    error = TRUE
  )
})
