### [GENERATED AUTOMATICALLY] Update test-explicit_namespace.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("using base namespace works", {
  test <- polars::pl$LazyFrame(x = 1:3)

  expect_equal_lazy(
    test |> mutate(y = sum(x)),
    test |> mutate(y = base::sum(x))
  )
})

test_that("using other package namespace works", {
  test <- polars::pl$LazyFrame(x = 1:3)

  expect_equal_lazy(
    test |> mutate(y = lag(x)),
    test |> mutate(y = dplyr::lag(x))
  )

  expect_equal_lazy(
    test |> summarize(y = lag(x)),
    test |> summarize(y = dplyr::lag(x))
  )

  expect_equal_lazy(
    test |> filter(x == first(x)),
    test |> filter(x == dplyr::first(x))
  )
})

test_that("error message when function exists but has no translation", {
  test <- polars::pl$LazyFrame(x = 1:3)

  expect_error_lazy(
    test |> mutate(y = data.table::shift(x)),
    "doesn't know how to translate this function: `data.table::shift()",
    fixed = TRUE
  )

  suppressPackageStartupMessages(library("data.table"))
  expect_error_lazy(
    test |> mutate(y = year(x)),
    "doesn't know how to translate this function: `year()` (from package `data.table`)",
    fixed = TRUE
  )
  detach("package:data.table", unload = TRUE)
})

test_that("error message when function doesn't exist in environment", {
  test <- polars::pl$LazyFrame(x = 1:3)

  expect_error_lazy(
    test |> mutate(y = foobar(x)),
    "doesn't know how to translate this function: `foobar()`.",
    fixed = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)