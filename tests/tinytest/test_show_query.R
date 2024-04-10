source("helpers.R")
using("tidypolars")

expect_snapshot_print(
  label = "simple_filter_query",
  {
    iris |>
      as_polars_df() |>
      filter(Sepal.Length > 5, Species %in% c("setosa", "virginica")) |>
      show_query()
  }
)

expect_snapshot_print(
  label = "simple_select_query",
  {
    iris |>
      as_polars_df() |>
      select(starts_with("Sep"), matches("ies$")) |>
      show_query()
  }
)

expect_snapshot_print(
  label = "simple_mutate_query",
  {
    iris |>
      as_polars_df() |>
      mutate(x = (Petal.Length / Petal.Width) > 3) |>
      show_query()
  }
)

expect_snapshot_print(
  label = "simple_arrange_query",
  {
    iris |>
      as_polars_df() |>
      arrange(Sepal.Length, -Sepal.Width, desc(Species)) |>
      show_query()
  }
)

expect_snapshot_print(
  label = "complex_query",
  {
    tidyr::relig_income |>
      as_polars_df() |>
      pivot_longer(!religion, names_to = "income", values_to = "count") |>
      drop_na() |>
      arrange(religion, count) |>
      show_query()
  }
)
