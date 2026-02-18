### [GENERATED AUTOMATICALLY] Update test-group_by.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("Arg `.drop` is not supported in group_by()", {
  # tidypolars-specific (tidypolars doesn't support .drop argument)
  test_df <- as_tibble(iris)
  test_pl <- as_polars_lf(test_df)

  expect_snapshot_lazy(
    test_pl |> group_by(Species, .drop = FALSE),
    error = TRUE
  )
})

test_that("group_by() doesn't support named expressions, #233", {
  # tidypolars-specific (tidypolars doesn't support named expressions in group_by)
  test_df <- as_tibble(iris)
  test_pl <- as_polars_lf(test_df)

  expect_snapshot_lazy(
    test_pl |>
      group_by(is_present = !is.na(Sepal.Length)) |>
      count(),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
