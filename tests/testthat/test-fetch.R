test_that("can only be used on LazyFrame", {
  expect_snapshot(
    fetch(as_polars_df(iris)),
    error = TRUE
  )
})

test_that("is deprecated", {
  expect_snapshot(fetch(as_polars_lf(iris)))
})
