test_that("basic behavior works", {
  pl_iris <- pl$DataFrame(iris)
  pl_iris_lazy <- pl$LazyFrame(iris)

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

test_that("can't collect non-LazyFrame object", {
  pl_iris <- pl$DataFrame(iris)

  expect_snapshot(
    collect(pl_iris),
    error = TRUE
  )
})
