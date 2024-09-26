### [GENERATED AUTOMATICALLY] Update test-by.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that(".by doesn't work on already grouped data", {
  expect_error_lazy(
    as_polars_df(iris) |>
      group_by(Species) |>
      mutate(foo = 1, .by = Species),
    "Can't supply `.by` when `.data` is a grouped DataFrame or LazyFrame."
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)