test_that("make_unique_id() is deprecated", {
  expect_snapshot(
    make_unique_id(as_polars_df(mtcars))
  )
})
