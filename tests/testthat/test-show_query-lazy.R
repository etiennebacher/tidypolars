### [GENERATED AUTOMATICALLY] Update test-show_query.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("simple filter query", {
  expect_snapshot_lazy(
    iris |>
      as_polars_lf() |>
      filter(Sepal.Length > 5) |>
      show_query()
  )
})

test_that("simple selectquery", {
  expect_snapshot_lazy(
    iris |>
      as_polars_lf() |>
      select(starts_with("Sep"), matches("ies$")) |>
      show_query()
  )
})

test_that("simple mutate query", {
  expect_snapshot_lazy(
    iris |>
      as_polars_lf() |>
      mutate(x = (Petal.Length / Petal.Width) > 3) |>
      show_query()
  )
})

test_that("simple arrange query", {
  expect_snapshot_lazy(
    iris |>
      as_polars_lf() |>
      arrange(Sepal.Length, -Sepal.Width, desc(Species)) |>
      show_query()
  )
})

test_that("complex_query", {
  expect_snapshot_lazy(
    tidyr::relig_income |>
      as_polars_lf() |>
      pivot_longer(!religion, names_to = "income", values_to = "count") |>
      drop_na() |>
      arrange(religion, count) |>
      show_query()
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)