### [GENERATED AUTOMATICALLY] Update test-group_by.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("Arg `.drop` is not supported in group_by()", {
  expect_snapshot_lazy(
    iris |>
      as_polars_lf() |>
      group_by(Species, .drop = FALSE),
    error = TRUE
  )
})

test_that("group_by() doesn't support named expressions, #233", {
  expect_snapshot_lazy(
    iris |>
      as_polars_lf() |>
      group_by(is_present = !is.na(Sepal.Length)) |>
      count(),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
