test_that("simple filter query", {
  expect_snapshot(
    iris |>
      as_polars_df() |>
      filter(Sepal.Length > 5) |>
      show_query()
  )
})

test_that("simple selectquery", {
  expect_snapshot(
    iris |>
      as_polars_df() |>
      select(starts_with("Sep"), matches("ies$")) |>
      show_query()
  )
})

test_that("simple mutate query", {
  expect_snapshot(
    iris |>
      as_polars_df() |>
      mutate(x = (Petal.Length / Petal.Width) > 3) |>
      show_query()
  )
})

test_that("simple arrange query", {
  expect_snapshot(
    iris |>
      as_polars_df() |>
      arrange(Sepal.Length, -Sepal.Width, desc(Species)) |>
      show_query()
  )
})

test_that("complex_query", {
  expect_snapshot(
    tidyr::relig_income |>
      as_polars_df() |>
      pivot_longer(!religion, names_to = "income", values_to = "count") |>
      drop_na() |>
      arrange(religion, count) |>
      show_query()
  )
})
