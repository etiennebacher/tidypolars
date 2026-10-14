### [GENERATED AUTOMATICALLY] Update test-uncount.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test_df <- tibble(value = c("a", "b"), y = 100:101, n = c(1L, 2L))
  test_pl <- as_polars_lf(test_df)

  expect_is_tidypolars(uncount(test_pl, n))

  expect_equal_lazy(
    uncount(test_pl, n),
    uncount(test_df, n)
  )

  expect_equal_lazy(
    uncount(test_pl, n, .id = "id"),
    uncount(test_df, n, .id = "id")
  )

  expect_equal_lazy(
    uncount(test_pl, n, .remove = FALSE),
    uncount(test_df, n, .remove = FALSE)
  )
})

test_that("works with constant", {
  test_df <- tibble(x = c("a", "b"), y = 100:101, n = c(1L, 2L))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    uncount(test_pl, 2),
    uncount(test_df, 2)
  )
})

test_that("works with expression", {
  test_df <- tibble(x = c("a", "b"), y = 100:101, n = c(1L, 2L))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    uncount(test_pl, 2 / n),
    uncount(test_df, 2 / n)
  )
  expect_equal_lazy(
    uncount(test_pl, n * 2),
    uncount(test_df, n * 2)
  )
  expect_equal_lazy(
    uncount(test_pl, .data$n),
    uncount(test_df, .data$n)
  )
  expect_equal_lazy(
    uncount(test_pl, 2),
    uncount(test_df, 2)
  )
})

test_that("weights respect the calling environment", {
  test_df <- tibble(value = c("a", "b"), n = c(1L, 2L))
  test_pl <- as_polars_lf(test_df)
  multiplier <- 2L

  expect_equal_lazy(
    uncount(test_pl, n * multiplier),
    uncount(test_df, n * multiplier)
  )
  expect_equal_lazy(
    uncount(test_pl, n * .env$multiplier),
    uncount(test_df, n * .env$multiplier)
  )

  expand <- function(data, weights) uncount(data, {{ weights }})
  expect_equal_lazy(
    expand(test_pl, n * .env$multiplier),
    expand(test_df, n * .env$multiplier)
  )
})

test_that("ids restart for identical rows and missing values", {
  test_df <- tibble(value = c("a", "b", NA), n = c(2L, 2L, 2L))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    uncount(test_pl, n, .id = "id"),
    uncount(test_df, n, .id = "id")
  )
})

test_that("zero weights and empty input produce no placeholder rows", {
  test_df <- tibble(value = c("a", "b"), n = c(0L, 2L))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    uncount(test_pl, n, .id = "id"),
    uncount(test_df, n, .id = "id")
  )
  expect_equal_lazy(
    uncount(test_pl, 0, .id = "id"),
    uncount(test_df, 0, .id = "id")
  )

  test_df <- tibble(value = character(0), n = integer(0))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    uncount(test_pl, n, .id = "id"),
    uncount(test_df, n, .id = "id")
  )
  expect_equal_lazy(
    uncount(test_pl, 2),
    uncount(test_df, 2)
  )
})

test_that("integer-valued doubles and logical weights are accepted", {
  test_df <- tibble(value = c("a", "b"), n = c(1, 2), flag = c(TRUE, FALSE))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    uncount(test_pl, n),
    uncount(test_df, n)
  )
  expect_equal_lazy(
    uncount(test_pl, flag),
    uncount(test_df, flag)
  )
})

test_that("weights are validated before expansion", {
  test_df <- tibble(
    value = c("a", "b"),
    missing = c(1, NA),
    fraction = c(1, 1.5),
    negative_fraction = c(1, -0.5),
    negative = c(1, -1),
    infinite = c(1, Inf),
    nan = c(1, NaN),
    text = c("1", "2"),
    oversized = c(1, 2147483648)
  )
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    uncount(test_pl, missing),
    uncount(test_df, missing)
  )
  expect_both_error(
    uncount(test_pl, fraction),
    uncount(test_df, fraction)
  )
  expect_both_error(
    uncount(test_pl, negative_fraction),
    uncount(test_df, negative_fraction)
  )
  expect_both_error(
    uncount(test_pl, negative),
    uncount(test_df, negative)
  )
  expect_both_error(
    uncount(test_pl, infinite),
    uncount(test_df, infinite)
  )
  expect_both_error(
    uncount(test_pl, nan),
    uncount(test_df, nan)
  )
  expect_both_error(
    uncount(test_pl, text),
    uncount(test_df, text)
  )
  expect_both_error(
    uncount(test_pl, oversized),
    uncount(test_df, oversized)
  )
  expect_both_error(
    uncount(test_pl, c(1L, 2L, 3L)),
    uncount(test_df, c(1L, 2L, 3L))
  )

  # The error message is hard to read now. Perhaps we can find a
  # more general error-handling solution for LazyFrame.
  expect_snapshot_lazy(uncount(test_pl, missing), error = TRUE)
})

test_that("weights must be supplied and cannot evaluate to NULL", {
  test_df <- tibble(value = "a", n = 2L)
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    uncount(test_pl),
    uncount(test_df)
  )
  expect_snapshot_lazy(uncount(test_pl), error = TRUE)
  expect_snapshot_lazy(uncount(test_pl, NULL), error = TRUE)
})

test_that("control arguments are validated", {
  test_df <- tibble(value = "a", n = 2L)
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    uncount(test_pl, n, .remove = NA),
    uncount(test_df, n, .remove = NA)
  )
  expect_both_error(
    uncount(test_pl, n, .remove = 1),
    uncount(test_df, n, .remove = 1)
  )
  expect_snapshot_lazy(uncount(test_pl, n, .remove = NA), error = TRUE)

  expect_both_error(
    uncount(test_pl, n, .id = ""),
    uncount(test_df, n, .id = "")
  )
  expect_both_error(
    uncount(test_pl, n, .id = c("a", "b")),
    uncount(test_df, n, .id = c("a", "b"))
  )
  expect_snapshot_lazy(uncount(test_pl, n, .id = ""), error = TRUE)
})

test_that("id replacement and temporary names preserve other columns", {
  test_df <- tibble(
    value = "a",
    id = 10L,
    n = 2L,
    `__tidypolars_uncount__` = 5L
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    uncount(test_pl, n, .id = "id"),
    uncount(test_df, n, .id = "id")
  )
  expect_equal_lazy(
    uncount(test_pl, n, .id = "n"),
    uncount(test_df, n, .id = "n")
  )
  expect_equal_lazy(
    uncount(test_pl, n, .remove = FALSE, .id = "n"),
    uncount(test_df, n, .remove = FALSE, .id = "n")
  )
  expect_equal_lazy(
    uncount(test_pl, n, .id = "__tidypolars_uncount__"),
    uncount(test_df, n, .id = "__tidypolars_uncount__")
  )
})

test_that("weights use group context and retained groups survive", {
  test_df <- tibble(
    g = c("a", "b", "c"),
    value = 1:3,
    n = c(1L, 2L, 1L)
  )
  test_pl <- as_polars_lf(test_df)

  test_df <- test_df |> group_by(g)
  test_pl <- test_pl |> group_by(g, maintain_order = TRUE)

  expect_equal_lazy(
    uncount(test_pl, n),
    uncount(test_df, n)
  )
  expect_equal_lazy(
    uncount(test_pl, n(), .id = "id"),
    uncount(test_df, n(), .id = "id")
  )
  expect_equal_lazy(
    uncount(test_pl, sum(n)),
    uncount(test_df, sum(n))
  )
  expect_equal_lazy(
    group_vars(uncount(test_pl, n)),
    group_vars(uncount(test_df, n))
  )
  expect_equal_lazy(
    uncount(test_pl, n) |> summarise(total = n()) |> arrange(g),
    uncount(test_df, n) |> summarise(total = n()) |> arrange(g)
  )
})

test_that("removing the last grouping column ungroups the result", {
  test_df <- tibble(value = c("a", "b"), n = c(1L, 2L))
  test_pl <- as_polars_lf(test_df)
  test_df <- group_by(test_df, n)
  test_pl <- group_by(test_pl, n, maintain_order = TRUE)

  expect_equal_lazy(
    uncount(test_pl, n),
    uncount(test_df, n)
  )
  expect_equal_lazy(
    uncount(test_pl, n) |> summarise(total = n()),
    uncount(test_df, n) |> summarise(total = n())
  )
  expect_equal_lazy(
    group_vars(uncount(test_pl, n, .remove = FALSE)),
    group_vars(uncount(test_df, n, .remove = FALSE))
  )
})

test_that("removed grouping columns are not restored", {
  test_df <- tibble(g = c("a", "b"), n = c(1L, 2L))
  test_pl <- as_polars_lf(test_df)

  test_df <- test_df |> group_by(g, n)
  test_pl <- test_pl |> group_by(g, n, maintain_order = TRUE)

  expect_equal_lazy(
    uncount(test_pl, n),
    uncount(test_df, n)
  )
  expect_equal_lazy(
    group_vars(uncount(test_pl, n)),
    group_vars(uncount(test_df, n))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
