### [GENERATED AUTOMATICALLY] Update test-make_unique_id.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("make_unique_id() is deprecated", {
  expect_snapshot_lazy(
    make_unique_id(as_polars_lf(mtcars))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
