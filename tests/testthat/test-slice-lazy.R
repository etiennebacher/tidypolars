### [GENERATED AUTOMATICALLY] Update test-slice.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  iris_pl <- polars::as_polars_lf(iris)

  expect_is_tidypolars(slice_head(iris_pl, n = 1))
  expect_is_tidypolars(slice_tail(iris_pl, n = 1))

  expect_equal_lazy(
    slice_head(iris_pl, n = 5),
    head(iris, n = 5),
    ignore_attr = TRUE
  )
})

test_that("slice_head works with grouped data", {
  iris_pl <- polars::as_polars_lf(iris)
  iris_g_pl <- iris_pl |>
    group_by(Species, maintain_order = TRUE)

  hd <- slice_head(iris_g_pl, n = 2)

  expect_equal_lazy(
    pull(hd, Species),
    iris |>
      dplyr::group_by(Species) |>
      dplyr::slice_head(n = 2) |>
      dplyr::pull(Species)
  )

  expect_equal_lazy(
    iris_pl |>
      slice_head(iris_g_pl, n = 2, by = Species) |>
      pull(Species) |>
      sort(),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_equal_lazy(
    hd,
    iris |>
      dplyr::group_by(Species) |>
      dplyr::slice_head(n = 2) |>
      as.data.frame()
  )

  expect_equal_lazy(
    pull(hd, Sepal.Length)[3:4],
    iris |>
      dplyr::group_by(Species) |>
      dplyr::slice_head(n = 2) |>
      dplyr::pull(Sepal.Length) |>
      (\(x) x[3:4])()
  )

  expect_equal_lazy(
    attr(hd, "pl_grps"),
    "Species"
  )

  expect_true(attr(hd, "maintain_grp_order"))
})

test_that("slice_tail works on grouped data", {
  iris_pl <- polars::as_polars_lf(iris)
  iris_g_pl <- iris_pl |>
    group_by(Species, maintain_order = TRUE)
  tl <- slice_tail(iris_g_pl, n = 2)

  expect_equal_lazy(
    pull(tl, Species),
    iris |>
      dplyr::group_by(Species) |>
      dplyr::slice_tail(n = 2) |>
      dplyr::pull(Species)
  )

  expect_equal_lazy(
    iris_pl |>
      slice_tail(iris_g_pl, n = 2, by = Species) |>
      pull(Species) |>
      sort(),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_equal_lazy(
    tl,
    iris |>
      dplyr::group_by(Species) |>
      dplyr::slice_tail(n = 2) |>
      as.data.frame()
  )

  expect_equal_lazy(
    pull(tl, Sepal.Length)[3:4],
    iris |>
      dplyr::group_by(Species) |>
      dplyr::slice_tail(n = 2) |>
      dplyr::pull(Sepal.Length) |>
      (\(x) x[3:4])()
  )

  expect_equal_lazy(
    attr(tl, "pl_grps"),
    "Species"
  )

  expect_true(attr(tl, "maintain_grp_order"))
})

test_that("basic slice_sample works", {
  iris_pl <- polars::as_polars_lf(iris)
  skip_if_not(is_polars_df(iris_pl))

  expect_is_tidypolars(slice_sample(iris_pl, prop = 0.1))

  expect_equal_lazy(
    slice_sample(iris_pl) |> nrow(),
    1
  )

  expect_equal_lazy(
    slice_sample(iris_pl, n = 5) |> nrow(),
    5
  )

  expect_equal_lazy(
    slice_sample(iris_pl, prop = 0.1) |> nrow(),
    15
  )

  expect_snapshot_lazy(
    slice_sample(iris_pl, n = 2, prop = 0.1),
    error = TRUE
  )

  expect_equal_lazy(
    slice_sample(iris_pl, n = 200, replace = TRUE) |> nrow(),
    200
  )

  expect_snapshot_lazy(
    slice_sample(iris_pl, n = 200),
    error = TRUE
  )

  expect_equal_lazy(
    slice_sample(iris_pl, prop = 2, replace = TRUE) |> nrow(),
    300
  )

  expect_snapshot_lazy(
    slice_sample(iris_pl, prop = 1.2),
    error = TRUE
  )

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
  iris_pl <- polars::as_polars_lf(iris)
  skip_if_not(is_polars_df(iris_pl))

  expect_equal_lazy(
    iris_pl |>
      group_by(Species) |>
      slice_sample(n = 5) |>
      nrow(),
    15
  )

  expect_equal_lazy(
    iris_pl |>
      group_by(Species) |>
      slice_sample(n = 5) |>
      attr("pl_grps"),
    "Species"
  )

  expect_true(
    iris_pl |>
      group_by(Species, maintain_order = TRUE) |>
      slice_sample(n = 5) |>
      attr("maintain_grp_order")
  )

  expect_equal_lazy(
    iris_pl |>
      slice_sample(n = 5, by = Species) |>
      nrow(),
    15
  )

  expect_equal_lazy(
    iris_pl |>
      slice_sample(prop = 0.1, by = Species) |>
      nrow(),
    15
  )

  expect_null(
    iris_pl |>
      slice_sample(prop = 0.1, by = Species) |>
      attr("pl_grps")
  )

  expect_null(
    iris_pl |>
      slice_sample(prop = 0.1, by = Species) |>
      attr("maintain_grp_order")
  )
})

test_that("unsupported args throw warning", {
  mtcars_pl <- as_polars_lf(mtcars)
  skip_if_not(is_polars_df(mtcars_pl))
  expect_warning(
    slice_sample(mtcars_pl, weight_by = cyl > 5, n = 5)
  )
})

test_that("dots must be empty", {
  mtcars_pl <- as_polars_lf(mtcars)
  skip_if_not(is_polars_df(mtcars_pl))
  expect_snapshot_lazy(
    mtcars_pl |>
      slice_sample(foo = 1, n = 5),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
