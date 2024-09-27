test_that("basic behavior works", {
  pl_iris <- polars::pl$DataFrame(iris)

  expect_is_tidypolars(slice_head(pl_iris, n = 1))
  expect_is_tidypolars(slice_tail(pl_iris, n = 1))

  expect_equal(
    slice_head(pl_iris, n = 5),
    head(iris, n = 5),
    ignore_attr = TRUE
  )

  # TODO: fails now?
  # expect_equal(
  #   slice_tail(pl_iris, n = 5),
  #   tail(iris, n = 5),
  #   ignore_attr = TRUE
  # )
})

test_that("slice_head works with grouped data", {
  pl_iris <- polars::pl$DataFrame(iris)
  pl_iris_g <- pl_iris |>
    group_by(Species, maintain_order = TRUE)

  hd <- slice_head(pl_iris_g, n = 2)

  expect_equal(
    pull(hd, Species),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_equal(
    pl_iris |>
      slice_head(pl_iris_g, n = 2, by = Species) |>
      pull(Species) |>
      sort(),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_dim(hd, c(6, 5))

  expect_equal(
    pull(hd, Sepal.Length)[3:4],
    c(7, 6.4)
  )

  expect_equal(
    attr(hd, "pl_grps"),
    "Species"
  )

  expect_equal(
    attr(hd, "maintain_grp_order"),
    TRUE
  )
})

test_that("slice_tail works on grouped data", {
  pl_iris <- polars::pl$DataFrame(iris)
  pl_iris_g <- pl_iris |>
    group_by(Species, maintain_order = TRUE)
  tl <- slice_tail(pl_iris_g, n = 2)

  expect_equal(
    pull(tl, Species),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_equal(
    pl_iris |>
      slice_tail(pl_iris_g, n = 2, by = Species) |>
      pull(Species) |>
      sort(),
    factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
  )

  expect_dim(tl, c(6, 5))

  expect_equal(
    pull(tl, Sepal.Length)[3:4],
    c(5.1, 5.7)
  )

  expect_equal(
    attr(tl, "pl_grps"),
    "Species"
  )

  expect_equal(
    attr(tl, "maintain_grp_order"),
    TRUE
  )
})

test_that("slice_sample works", {
  pl_iris <- polars::pl$DataFrame(iris)
  skip_if_not(inherits(pl_iris, "RPolarsDataFrame"))

  expect_is_tidypolars(slice_sample(pl_iris, prop = 0.1))

  expect_equal(
    slice_sample(pl_iris) |> nrow(),
    1
  )

  expect_equal(
    slice_sample(pl_iris, n = 5) |> nrow(),
    5
  )

  expect_equal(
    slice_sample(pl_iris, prop = 0.1) |> nrow(),
    15
  )

  expect_snapshot(
    slice_sample(pl_iris, n = 2, prop = 0.1),
    error = TRUE
  )

  expect_equal(
    slice_sample(pl_iris, n = 200, replace = TRUE) |> nrow(),
    200
  )

  expect_snapshot(
    slice_sample(pl_iris, n = 200),
    error = TRUE
  )

  expect_equal(
    slice_sample(pl_iris, prop = 2, replace = TRUE) |> nrow(),
    300
  )

  expect_snapshot(
    slice_sample(pl_iris, prop = 1.2),
    error = TRUE
  )

  expect_equal(
    pl_iris |>
      group_by(Species) |>
      slice_sample(n = 5) |>
      nrow(),
    15
  )

  expect_equal(
    pl_iris |>
      group_by(Species) |>
      slice_sample(n = 5) |>
      attr("pl_grps"),
    "Species"
  )

  expect_equal(
    pl_iris |>
      group_by(Species, maintain_order = TRUE) |>
      slice_sample(n = 5) |>
      attr("maintain_grp_order"),
    TRUE
  )

  expect_equal(
    pl_iris |>
      slice_sample(n = 5, by = Species) |>
      nrow(),
    15
  )

  expect_equal(
    pl_iris |>
      slice_sample(prop = 0.1, by = Species) |>
      nrow(),
    15
  )

  expect_equal(
    pl_iris |>
      slice_sample(prop = 0.1, by = Species) |>
      attr("pl_grps"),
    NULL
  )

  expect_equal(
    pl_iris |>
      slice_sample(prop = 0.1, by = Species) |>
      attr("maintain_grp_order"),
    NULL
  )
})
