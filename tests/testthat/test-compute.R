test_that("basic behavior works", {
  pl_iris <- as_polars_df(iris)
  pl_iris_lazy <- as_polars_lf(iris)

  expect_is_tidypolars(compute(pl_iris_lazy))

  expect_equal(
    compute(pl_iris_lazy),
    pl_iris
  )

  expect_equal(
    pl_iris_lazy |>
      filter(Species == "setosa") |>
      compute(),
    pl_iris |>
      filter(Species == "setosa")
  )

  out <- pl_iris_lazy |>
    group_by(Species, maintain_order = TRUE) |>
    compute()

  expect_equal(
    attr(out, "pl_grps"),
    "Species"
  )

  expect_true(attr(out, "maintain_grp_order"))
})

test_that("deprecated arguments in compute()", {
  test <- as_polars_lf(mtcars)
  expect_snapshot({
    x <- compute(test, streaming = TRUE)
  })
})

test_that("can't collect non-LazyFrame object", {
  pl_iris <- as_polars_df(iris)
  expect_snapshot(
    compute(pl_iris),
    error = TRUE
  )
})

test_that("error on unknown args", {
  pl_iris <- as_polars_lf(iris)

  expect_snapshot(
    compute(pl_iris, foo = TRUE),
    error = TRUE
  )
})
