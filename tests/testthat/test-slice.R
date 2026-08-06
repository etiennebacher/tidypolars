test_that("basic behavior works", {
  test_df <- as_tibble(iris)
  # TODO: shouldn't be needed
  test_df$Species <- as.character(test_df$Species)
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(slice_head(test_pl, n = 1))
  expect_is_tidypolars(slice_tail(test_pl, n = 1))

  expect_equal(
    slice_head(test_pl, n = 5),
    slice_head(test_df, n = 5)
  )
})

test_that("slice_head works with grouped data", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)
  test_pl_grp <- test_pl |>
    group_by(Species, maintain_order = TRUE)
  test_grp <- test_df |>
    group_by(Species)

  expect_equal(
    slice_head(test_pl_grp, n = 2) |> ungroup(),
    slice_head(test_grp, n = 2) |> ungroup()
  )

  expect_equal(
    test_pl |>
      slice_head(n = 2, by = Species) |>
      arrange(Species, Sepal.Length),
    test_df |> slice_head(n = 2, by = Species) |> arrange(Species, Sepal.Length)
  )

  # tidypolars-specific attributes
  expect_equal(
    attr(slice_head(test_pl_grp, n = 2), "pl_grps"),
    "Species"
  )

  expect_true(attr(slice_head(test_pl_grp, n = 2), "maintain_grp_order"))
})

test_that("grouped head and tail with zero rows return zero rows", {
  test_df <- tibble(g = c("a", "a", "b"), x = 1:3)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> group_by(g) |> slice_head(n = 0),
    test_df |> group_by(g) |> slice_head(n = 0)
  )

  expect_equal(
    test_pl |> group_by(g) |> slice_tail(n = 0),
    test_df |> group_by(g) |> slice_tail(n = 0)
  )
})

test_that("slice_tail works on grouped data", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)
  test_pl_grp <- test_pl |>
    group_by(Species, maintain_order = TRUE)
  test_grp <- test_df |>
    group_by(Species)

  expect_equal(
    slice_tail(test_pl_grp, n = 2) |> ungroup(),
    slice_tail(test_grp, n = 2) |> ungroup()
  )

  expect_equal(
    test_pl |>
      slice_tail(n = 2, by = Species) |>
      arrange(Species, Sepal.Length),
    test_df |> slice_tail(n = 2, by = Species) |> arrange(Species, Sepal.Length)
  )

  # tidypolars-specific attributes
  expect_equal(
    attr(slice_tail(test_pl_grp, n = 2), "pl_grps"),
    "Species"
  )

  expect_true(attr(slice_tail(test_pl_grp, n = 2), "maintain_grp_order"))
})

test_that("basic slice_sample works", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))

  expect_is_tidypolars(slice_sample(test_pl, prop = 0.1))

  expect_equal(
    slice_sample(test_pl) |> nrow(),
    slice_sample(test_df) |> nrow()
  )

  expect_equal(
    slice_sample(test_pl, n = 5) |> nrow(),
    slice_sample(test_df, n = 5) |> nrow()
  )

  expect_equal(
    slice_sample(test_pl, prop = 0.1) |> nrow(),
    slice_sample(test_df, prop = 0.1) |> nrow()
  )

  expect_both_error(
    slice_sample(test_pl, n = 2, prop = 0.1),
    slice_sample(test_df, n = 2, prop = 0.1)
  )
  expect_snapshot(
    slice_sample(test_pl, n = 2, prop = 0.1),
    error = TRUE
  )

  expect_equal(
    slice_sample(test_pl, n = 200, replace = TRUE) |> nrow(),
    slice_sample(test_df, n = 200, replace = TRUE) |> nrow()
  )

  expect_equal(
    slice_sample(test_pl, prop = 2, replace = TRUE) |> nrow(),
    slice_sample(test_df, prop = 2, replace = TRUE) |> nrow()
  )

  # slice_sample keeps rows consistent
  test_pl <- pl$DataFrame(x = 1:3, y = letters[1:3], z = 4:6)
  foo <- slice_sample(test_pl, n = 1)

  if (pull(foo, x) == 1) {
    expect_equal(pull(foo, y), "a")
    expect_equal(pull(foo, z), 4)
  } else if (pull(foo, x) == 2) {
    expect_equal(pull(foo, y), "b")
    expect_equal(pull(foo, z), 5)
  } else if (pull(foo, x) == 3) {
    expect_equal(pull(foo, y), "c")
    expect_equal(pull(foo, z), 6)
  }
})

test_that("slice_sample works with grouped data", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))

  expect_equal(
    test_pl |> group_by(Species) |> slice_sample(n = 5) |> nrow(),
    test_df |> group_by(Species) |> slice_sample(n = 5) |> nrow()
  )

  # tidypolars-specific attributes
  expect_equal(
    test_pl |> group_by(Species) |> slice_sample(n = 5) |> attr("pl_grps"),
    "Species"
  )

  expect_true(
    test_pl |>
      group_by(Species, maintain_order = TRUE) |>
      slice_sample(n = 5) |>
      attr("maintain_grp_order")
  )

  expect_equal(
    test_pl |> slice_sample(n = 5, by = Species) |> nrow(),
    test_df |> slice_sample(n = 5, by = Species) |> nrow()
  )

  expect_equal(
    test_pl |> slice_sample(prop = 0.1, by = Species) |> nrow(),
    test_df |> slice_sample(prop = 0.1, by = Species) |> nrow()
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

  # slice_sample by group keeps rows consistent
  test_pl <- pl$DataFrame(g = c("a", "a", "b", "b"), x = 1:4, y = 5:8) |>
    group_by(g)
  foo <- slice_sample(test_pl, n = 1)

  g1 <- filter(foo, g == "a")
  g2 <- filter(foo, g == "b")

  if (pull(g1, x) == 1) {
    expect_equal(pull(g1, y), 5)
  } else if (pull(g1, x) == 2) {
    expect_equal(pull(g1, y), 6)
  }

  if (pull(g2, x) == 3) {
    expect_equal(pull(g2, y), 7)
  } else if (pull(g2, x) == 4) {
    expect_equal(pull(g2, y), 8)
  }
})

test_that("slice_sample() truncates n and prop if they are too large", {
  test_df <- tibble(x = 1:5, y = 6:10)
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))

  expect_equal(
    test_pl |> slice_sample(n = 200) |> arrange(x, y),
    test_df |> slice_sample(n = 200) |> arrange(x, y)
  )
  expect_equal(
    test_pl |> slice_sample(prop = 1.5) |> arrange(x, y),
    test_df |> slice_sample(prop = 1.5) |> arrange(x, y)
  )
})

test_that("slice_sample() by group truncates n and prop if they are too large", {
  test_df <- tibble(g = c("a", "a", "b", "b", "b"), x = 1:5, y = 6:10)
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))

  expect_equal(
    test_pl |>
      group_by(g) |>
      slice_sample(n = 3) |>
      ungroup() |>
      count(g) |>
      arrange(g),
    test_df |>
      group_by(g) |>
      slice_sample(n = 3) |>
      ungroup() |>
      count(g) |>
      arrange(g)
  )

  expect_equal(
    test_pl |>
      group_by(g) |>
      slice_sample(prop = 1.5) |>
      ungroup() |>
      count(g) |>
      arrange(g),
    test_df |>
      group_by(g) |>
      slice_sample(prop = 1.5) |>
      ungroup() |>
      count(g) |>
      arrange(g)
  )

  expect_equal(
    test_pl |>
      slice_sample(n = 3, by = g) |>
      count(g) |>
      arrange(g),
    test_df |>
      slice_sample(n = 3, by = g) |>
      count(g) |>
      arrange(g)
  )
})

test_that("grouped slice_sample with zero rows returns zero rows", {
  test_df <- tibble(g = c("a", "a", "b"), x = 1:3)
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))

  expect_equal(
    test_pl |> group_by(g) |> slice_sample(n = 0),
    test_df |> group_by(g) |> slice_sample(n = 0)
  )
})

test_that("grouped slice_sample works with empty data", {
  test_df <- tibble(g = character(), x = integer())
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))

  expect_equal(
    test_pl |> group_by(g) |> slice_sample(n = 1),
    test_df |> group_by(g) |> slice_sample(n = 1)
  )

  expect_equal(
    test_pl |> slice_sample(n = 1, by = g),
    test_df |> slice_sample(n = 1, by = g)
  )
})

test_that("grouped slice_sample maintains group order when requested", {
  test_df <- tibble(g = c("b", "a", "b", "c", "a"), x = 1:5)
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))

  out <- test_pl |>
    group_by(g, maintain_order = TRUE) |>
    slice_sample(n = 5) |>
    distinct(g)
  expected <- test_df |>
    group_by(g) |>
    distinct(g)

  expect_equal(out, expected)
})

test_that("slice_sample works with different group structures", {
  test_df <- tibble(
    g1 = c("a", "a", "a", "b"),
    g2 = c(1L, 1L, 2L, 1L)
  )
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))

  group_only_df <- test_df |> select(g1)
  group_only_pl <- as_polars_df(group_only_df)
  expect_equal(
    group_only_pl |>
      group_by(g1) |>
      slice_sample(n = 2) |>
      ungroup() |>
      arrange(g1),
    group_only_df |>
      group_by(g1) |>
      slice_sample(n = 2) |>
      ungroup() |>
      arrange(g1)
  )

  expect_equal(
    test_pl |>
      group_by(g1, g2) |>
      slice_sample(n = 1) |>
      ungroup() |>
      count(g1, g2) |>
      arrange(g1, g2),
    test_df |>
      group_by(g1, g2) |>
      slice_sample(n = 1) |>
      ungroup() |>
      count(g1, g2) |>
      arrange(g1, g2)
  )

  expect_equal(
    test_pl |>
      group_by(g1, g2) |>
      slice_sample(n = 3, replace = TRUE) |>
      ungroup() |>
      count(g1, g2) |>
      arrange(g1, g2),
    test_df |>
      group_by(g1, g2) |>
      slice_sample(n = 3, replace = TRUE) |>
      ungroup() |>
      count(g1, g2) |>
      arrange(g1, g2)
  )
})

test_that("unsupported args throw warning", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))
  expect_warning(
    slice_sample(test_pl, weight_by = cyl > 5, n = 5)
  )
})

test_that("dots must be empty", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)
  skip_if_not(is_polars_df(test_pl))
  expect_both_error(
    test_pl |> slice_sample(foo = 1, n = 5),
    test_df |> slice_sample(foo = 1, n = 5)
  )
  expect_snapshot(
    test_pl |> slice_sample(foo = 1, n = 5),
    error = TRUE
  )
})
