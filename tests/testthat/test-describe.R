test_that("describe() is deprecated", {
  test <- as_polars_df(mtcars)
  expect_snapshot(describe(test))
})
