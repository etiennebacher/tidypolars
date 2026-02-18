### [GENERATED AUTOMATICALLY] Update test-explicit_namespace.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("using base namespace works", {
  test_pl <- pl$LazyFrame(x = 1:3)

  expect_equal_lazy(
    test_pl |> mutate(y = sum(x)),
    test_pl |> mutate(y = base::sum(x))
  )
})

test_that("using other package namespace works", {
  test_pl <- pl$LazyFrame(x = 1:3)

  expect_equal_lazy(
    test_pl |> mutate(y = first(x)),
    test_pl |> mutate(y = dplyr::first(x))
  )

  expect_equal_lazy(
    test_pl |> summarize(y = first(x)),
    test_pl |> summarize(y = dplyr::first(x))
  )

  expect_equal_lazy(
    test_pl |> filter(x == first(x)),
    test_pl |> filter(x == dplyr::first(x))
  )
})

test_that("error message when function exists but has no translation", {
  test_pl <- pl$LazyFrame(x = 1:3)
  expect_snapshot_lazy(
    test_pl |> mutate(y = data.table::shift(x)),
    error = TRUE
  )

  suppressPackageStartupMessages(library("data.table"))
  expect_snapshot_lazy(
    test_pl |> mutate(y = year(x)),
    error = TRUE
  )
  detach("package:data.table")
})

test_that("error message when function doesn't exist in environment", {
  test_pl <- pl$LazyFrame(x = 1:3)

  expect_snapshot_lazy(
    test_pl |> mutate(y = foobar(x)),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
