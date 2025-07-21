test_that("basic behavior works", {
  pl_iris <- as_polars_df(iris)
  pl_iris_lazy <- as_polars_lf(iris)

  expect_s3_class(collect(pl_iris_lazy), "data.frame")

  expect_equal(
    collect(pl_iris_lazy),
    iris
  )

  # TODO: droplevels() shouldn't be needed
  expect_equal(
    pl_iris_lazy |>
      filter(Species == "setosa") |>
      collect() |>
      droplevels(),
    iris[iris$Species == "setosa", ] |>
      droplevels(),
    ignore_attr = FALSE
  )
})

test_that("deprecated arguments in collect()", {
  test <- as_polars_lf(mtcars)
  expect_snapshot({
    x <- collect(test, streaming = TRUE)
  })
})

test_that("can't collect non-LazyFrame object", {
  pl_iris <- as_polars_df(iris)

  expect_snapshot(
    collect(pl_iris),
    error = TRUE
  )
})

test_that("error on unknown args", {
  pl_iris <- as_polars_lf(iris)

  expect_snapshot(
    collect(pl_iris, foo = TRUE),
    error = TRUE
  )
})

test_that("conversion arguments are used", {
  dat <- pl$LazyFrame(x = 1, y = 2)$cast(x = pl$UInt8, y = pl$Int64)
  expect_equal(
    collect(dat, uint8 = "raw", int64 = "character"),
    data.frame(x = as.raw(1), y = "2")
  )
})
