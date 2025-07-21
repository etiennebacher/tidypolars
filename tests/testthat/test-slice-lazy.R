### [GENERATED AUTOMATICALLY] Update test-slice.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  pl_iris <- polars::as_polars_lf(iris)

  expect_is_tidypolars(slice_head(pl_iris, n = 1))
  expect_is_tidypolars(slice_tail(pl_iris, n = 1))

  expect_equal_lazy(
    slice_head(pl_iris, n = 5),
    head(iris, n = 5),
    ignore_attr = TRUE
  )

  # TODO: fails now?
  # expect_equal_lazy(
  #   slice_tail(pl_iris, n = 5),
  #   tail(iris, n = 5),
  #   ignore_attr = TRUE
  # )
})

test_that("slice_head works with grouped data", {
  pl_iris <- polars::as_polars_lf(iris)
  pl_iris_g <- pl_iris |>
    group_by(Species, maintain_order = TRUE)

  hd <- slice_head(pl_iris_g, n = 2)

  expect_equal_lazy(
    pull(hd, Species),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_equal_lazy(
    pl_iris |>
      slice_head(pl_iris_g, n = 2, by = Species) |>
      pull(Species) |>
      sort(),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_dim(hd, c(6, 5))

  expect_equal_lazy(
    pull(hd, Sepal.Length)[3:4],
    c(7, 6.4)
  )

  expect_equal_lazy(
    attr(hd, "pl_grps"),
    "Species"
  )

  expect_true(attr(hd, "maintain_grp_order"))
})

test_that("slice_tail works on grouped data", {
  pl_iris <- polars::as_polars_lf(iris)
  pl_iris_g <- pl_iris |>
    group_by(Species, maintain_order = TRUE)
  tl <- slice_tail(pl_iris_g, n = 2)

  expect_equal_lazy(
    pull(tl, Species),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_equal_lazy(
    pl_iris |>
      slice_tail(pl_iris_g, n = 2, by = Species) |>
      pull(Species) |>
      sort(),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_dim(tl, c(6, 5))

  expect_equal_lazy(
    pull(tl, Sepal.Length)[3:4],
    c(5.1, 5.7)
  )

  expect_equal_lazy(
    attr(tl, "pl_grps"),
    "Species"
  )

  expect_true(attr(tl, "maintain_grp_order"))
})

test_that("basic slice_sample works", {
  pl_iris <- polars::as_polars_lf(iris)
  skip_if_not(is_polars_df(pl_iris))

  expect_is_tidypolars(slice_sample(pl_iris, prop = 0.1))

  expect_equal_lazy(
    slice_sample(pl_iris) |> nrow(),
    1
  )

  expect_equal_lazy(
    slice_sample(pl_iris, n = 5) |> nrow(),
    5
  )

  expect_equal_lazy(
    slice_sample(pl_iris, prop = 0.1) |> nrow(),
    15
  )

  expect_snapshot_lazy(
    slice_sample(pl_iris, n = 2, prop = 0.1),
    error = TRUE
  )

  expect_equal_lazy(
    slice_sample(pl_iris, n = 200, replace = TRUE) |> nrow(),
    200
  )

  expect_snapshot_lazy(
    slice_sample(pl_iris, n = 200),
    error = TRUE
  )

  expect_equal_lazy(
    slice_sample(pl_iris, prop = 2, replace = TRUE) |> nrow(),
    300
  )

  expect_snapshot_lazy(
    slice_sample(pl_iris, prop = 1.2),
    error = TRUE
  )

  # check that rows didn't mix column values
  foo <- pl$LazyFrame(x = 1:3, y = letters[1:3], z = 4:6) |>
    slice_sample(n = 1)

  if (pull(foo, x) == 1) {
    expect_equal_lazy(pull(foo, y), "a")
    expect_equal_lazy(pull(foo, z), 4)
  } else if (pull(foo, x) == 2) {
    expect_equal_lazy(pull(foo, y), "b")
    expect_equal_lazy(pull(foo, z), 5)
  } else if (pull(foo, x) == 3) {
    expect_equal_lazy(pull(foo, y), "c")
    expect_equal_lazy(pull(foo, z), 6)
  }
})

test_that("slice_sample works with grouped data", {
  pl_iris <- polars::as_polars_lf(iris)
  skip_if_not(is_polars_df(pl_iris))

  expect_equal_lazy(
    pl_iris |>
      group_by(Species) |>
      slice_sample(n = 5) |>
      nrow(),
    15
  )

  expect_equal_lazy(
    pl_iris |>
      group_by(Species) |>
      slice_sample(n = 5) |>
      attr("pl_grps"),
    "Species"
  )

  expect_true(
    pl_iris |>
      group_by(Species, maintain_order = TRUE) |>
      slice_sample(n = 5) |>
      attr("maintain_grp_order")
  )

  expect_equal_lazy(
    pl_iris |>
      slice_sample(n = 5, by = Species) |>
      nrow(),
    15
  )

  expect_equal_lazy(
    pl_iris |>
      slice_sample(prop = 0.1, by = Species) |>
      nrow(),
    15
  )

  expect_null(
    pl_iris |>
      slice_sample(prop = 0.1, by = Species) |>
      attr("pl_grps")
  )

  expect_null(
    pl_iris |>
      slice_sample(prop = 0.1, by = Species) |>
      attr("maintain_grp_order")
  )
})

test_that("unsupported args throw warning", {
  pl_mtcars <- as_polars_lf(mtcars)
  skip_if_not(is_polars_df(pl_mtcars))
  expect_warning(
    slice_sample(pl_mtcars, weight_by = cyl > 5, n = 5)
  )
})

test_that("dots must be empty", {
  pl_mtcars <- as_polars_lf(mtcars)
  skip_if_not(is_polars_df(pl_mtcars))
  expect_snapshot_lazy(
    pl_mtcars |>
      slice_sample(foo = 1, n = 5),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
