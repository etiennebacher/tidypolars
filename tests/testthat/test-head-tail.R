test_that("head() selects the first rows", {
  test_df <- as_tibble(iris) |> mutate(Species = as.character(Species))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    head(test_pl),
    head(test_df)
  )
  expect_equal(
    head(test_pl, 15),
    head(test_df, 15)
  )
  expect_equal(
    head(test_pl, 0),
    head(test_df, 0)
  )
  expect_equal(
    head(test_pl, 200),
    head(test_df, 200)
  )
})

test_that("tail() selects the last rows", {
  test_df <- as_tibble(iris) |> mutate(Species = as.character(Species))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    tail(test_pl),
    tail(test_df)
  )
  expect_equal(
    tail(test_pl, 15),
    tail(test_df, 15)
  )
  expect_equal(
    tail(test_pl, 0),
    tail(test_df, 0)
  )
  expect_equal(
    tail(test_pl, 200),
    tail(test_df, 200)
  )
})

test_that("negative n excludes rows from the opposite end", {
  test_df <- as_tibble(iris) |> mutate(Species = as.character(Species))
  test_pl <- as_polars_df(test_df)
  skip_if(
    is_polars_lf(test_pl),
    "Polars LazyFrames do not support negative n now."
  )

  expect_equal(
    head(test_pl, -10),
    head(test_df, -10)
  )
  expect_equal(
    head(test_pl, -200),
    head(test_df, -200)
  )
  expect_equal(
    tail(test_pl, -10),
    tail(test_df, -10)
  )
  expect_equal(
    tail(test_pl, -200),
    tail(test_df, -200)
  )
})

test_that("head() and tail() preserve empty inputs", {
  test_df <- tibble()
  test_pl <- as_polars_df(test_df)

  expect_equal(head(test_pl), head(test_df))
  expect_equal(tail(test_pl), tail(test_df))
})

test_that("head() preserves groups", {
  test_df <- as_tibble(iris) |> mutate(Species = as.character(Species))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> group_by(Species) |> head(30),
    test_df |> group_by(Species) |> head(30)
  )
  expect_equal(
    test_pl |>
      group_by(Species, maintain_order = TRUE) |>
      head(30) |>
      summarise(n = n()),
    test_df |>
      group_by(Species) |>
      head(30) |>
      summarise(n = n())
  )
})

test_that("tail() preserves groups", {
  test_df <- as_tibble(iris) |> mutate(Species = as.character(Species))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> group_by(Species) |> tail(30),
    test_df |> group_by(Species) |> tail(30)
  )
  expect_equal(
    test_pl |>
      group_by(Species, maintain_order = TRUE) |>
      tail(30) |>
      summarise(n = n()),
    test_df |>
      group_by(Species) |>
      tail(30) |>
      summarise(n = n())
  )
})

# TODO: Enable once r-polars preserves unused factor levels after slicing
# and conversion back to R. Currently these comparisons fail on factor levels.
# test_that("head() and tail() preserve factor levels in grouped data", {
#   test_df <- as_tibble(iris)
#   test_pl <- as_polars_df(test_df)

#   expect_equal(
#     test_pl |> group_by(Species) |> head(10),
#     test_df |> group_by(Species) |> head(10)
#   )
#   expect_equal(
#     test_pl |> group_by(Species) |> head(10) |> summarise(n = n()),
#     test_df |> group_by(Species) |> head(10) |> summarise(n = n())
#   )
#   expect_equal(
#     test_pl |> group_by(Species) |> tail(10),
#     test_df |> group_by(Species) |> tail(10)
#   )
#   expect_equal(
#     test_pl |> group_by(Species) |> tail(10) |> summarise(n = n()),
#     test_df |> group_by(Species) |> tail(10) |> summarise(n = n())
#   )
# })
