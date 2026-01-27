### [GENERATED AUTOMATICALLY] Update test-slice.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- as_tibble(iris)
  # TODO: shouldn't be needed
  test$Species <- as.character(test$Species)
  test_pl <- as_polars_lf(test)

  expect_is_tidypolars(slice_head(test_pl, n = 1))
  expect_is_tidypolars(slice_tail(test_pl, n = 1))

  expect_equal_lazy(
    slice_head(test_pl, n = 5),
    slice_head(test, n = 5)
  )
})

test_that("slice_head works with grouped data", {
  test <- as_tibble(iris)
  test_pl <- as_polars_lf(test)
  test_pl_grp <- test_pl |>
    group_by(Species, maintain_order = TRUE)
  test_grp <- test |>
    group_by(Species)

  expect_equal_lazy(
    slice_head(test_pl_grp, n = 2) |> ungroup(),
    slice_head(test_grp, n = 2) |> ungroup()
  )

  expect_equal_lazy(
    test_pl |>
      slice_head(n = 2, by = Species) |>
      arrange(Species, Sepal.Length),
    test |> slice_head(n = 2, by = Species) |> arrange(Species, Sepal.Length)
  )

  # tidypolars-specific attributes
  expect_equal_lazy(
    attr(slice_head(test_pl_grp, n = 2), "pl_grps"),
    "Species"
  )

  expect_true(attr(slice_head(test_pl_grp, n = 2), "maintain_grp_order"))
})

test_that("slice_tail works on grouped data", {
  test <- as_tibble(iris)
  test_pl <- as_polars_lf(test)
  test_pl_grp <- test_pl |>
    group_by(Species, maintain_order = TRUE)
  test_grp <- test |>
    group_by(Species)

  expect_equal_lazy(
    slice_tail(test_pl_grp, n = 2) |> ungroup(),
    slice_tail(test_grp, n = 2) |> ungroup()
  )

  expect_equal_lazy(
    test_pl |>
      slice_tail(n = 2, by = Species) |>
      arrange(Species, Sepal.Length),
    test |> slice_tail(n = 2, by = Species) |> arrange(Species, Sepal.Length)
  )

  # tidypolars-specific attributes
  expect_equal_lazy(
    attr(slice_tail(test_pl_grp, n = 2), "pl_grps"),
    "Species"
  )

  expect_true(attr(slice_tail(test_pl_grp, n = 2), "maintain_grp_order"))
})

test_that("basic slice_sample works", {
  test <- as_tibble(iris)
  test_pl <- as_polars_lf(test)
  skip_if_not(is_polars_df(test_pl))

  expect_is_tidypolars(slice_sample(test_pl, prop = 0.1))

  expect_equal_lazy(
    slice_sample(test_pl) |> nrow(),
    slice_sample(test) |> nrow()
  )

  expect_equal_lazy(
    slice_sample(test_pl, n = 5) |> nrow(),
    slice_sample(test, n = 5) |> nrow()
  )

  expect_equal_lazy(
    slice_sample(test_pl, prop = 0.1) |> nrow(),
    slice_sample(test, prop = 0.1) |> nrow()
  )

  expect_both_error(
    slice_sample(test_pl, n = 2, prop = 0.1),
    slice_sample(test, n = 2, prop = 0.1)
  )
  expect_snapshot_lazy(
    slice_sample(test_pl, n = 2, prop = 0.1),
    error = TRUE
  )

  expect_equal_lazy(
    slice_sample(test_pl, n = 200, replace = TRUE) |> nrow(),
    slice_sample(test, n = 200, replace = TRUE) |> nrow()
  )

  # TODO? dplyr chooses to take n_rows(data) if n > n_rows(data)
  # https://github.com/tidyverse/dplyr/issues/6185
  expect_snapshot_lazy(
    slice_sample(test_pl, n = 200),
    error = TRUE
  )

  expect_equal_lazy(
    slice_sample(test_pl, prop = 2, replace = TRUE) |> nrow(),
    slice_sample(test, prop = 2, replace = TRUE) |> nrow()
  )

  # TODO? dplyr chooses to take n_rows(data) if prop > 1
  expect_snapshot_lazy(
    slice_sample(test_pl, prop = 1.2),
    error = TRUE
  )

  # slice_sample keeps rows consistent
  test <- tibble(x = 1:3, y = letters[1:3], z = 4:6)
  test_pl <- as_polars_lf(test)
  foo <- slice_sample(test_pl, n = 1)

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
  test <- as_tibble(iris)
  test_pl <- as_polars_lf(test)
  skip_if_not(is_polars_df(test_pl))

  expect_equal_lazy(
    test_pl |> group_by(Species) |> slice_sample(n = 5) |> nrow(),
    test |> group_by(Species) |> slice_sample(n = 5) |> nrow()
  )

  # tidypolars-specific attributes
  expect_equal_lazy(
    test_pl |> group_by(Species) |> slice_sample(n = 5) |> attr("pl_grps"),
    "Species"
  )

  expect_true(
    test_pl |>
      group_by(Species, maintain_order = TRUE) |>
      slice_sample(n = 5) |>
      attr("maintain_grp_order")
  )

  expect_equal_lazy(
    test_pl |> slice_sample(n = 5, by = Species) |> nrow(),
    test |> slice_sample(n = 5, by = Species) |> nrow()
  )

  expect_equal_lazy(
    test_pl |> slice_sample(prop = 0.1, by = Species) |> nrow(),
    test |> slice_sample(prop = 0.1, by = Species) |> nrow()
  )

  # tidypolars-specific attributes
  expect_null(
    test_pl |> slice_sample(prop = 0.1, by = Species) |> attr("pl_grps")
  )

  expect_null(
    test_pl |>
      slice_sample(prop = 0.1, by = Species) |>
      attr("maintain_grp_order")
  )
})

test_that("unsupported args throw warning", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)
  skip_if_not(is_polars_df(test_pl))
  expect_warning(
    slice_sample(test_pl, weight_by = cyl > 5, n = 5)
  )
})

test_that("dots must be empty", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)
  skip_if_not(is_polars_df(test_pl))
  expect_both_error(
    test_pl |> slice_sample(foo = 1, n = 5),
    test |> slice_sample(foo = 1, n = 5)
  )
  expect_snapshot_lazy(
    test_pl |> slice_sample(foo = 1, n = 5),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
