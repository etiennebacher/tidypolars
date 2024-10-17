### [GENERATED AUTOMATICALLY] Update test-by.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that(".by doesn't work on already grouped data", {
  expect_snapshot_lazy(
    as_polars_lf(iris) |>
      group_by(Species) |>
      mutate(foo = 1, .by = Species),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)