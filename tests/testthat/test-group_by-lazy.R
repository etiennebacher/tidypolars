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

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
