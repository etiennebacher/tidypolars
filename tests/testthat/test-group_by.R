test_that("Arg `.drop` is not supported in group_by()", {
  # tidypolars-specific (tidypolars doesn't support .drop argument)
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_snapshot(
    test_pl |> group_by(Species, .drop = FALSE),
    error = TRUE
  )
})

test_that("group_by() works with expressions, #233, #345", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      group_by(is_present = !is.na(Sepal.Length)) |>
      count(),
    test_df |>
      group_by(is_present = !is.na(Sepal.Length)) |>
      count()
  )
  expect_equal(
    test_pl |>
      group_by(Sepal.Length > 5, Species) |>
      count(),
    test_df |>
      group_by(Sepal.Length > 5, Species) |>
      count()
  )
  expect_equal(
    test_pl |>
      group_by(Species) |>
      group_by(Sepal.Length > 5, .add = TRUE) |>
      count(),
    test_df |>
      group_by(Species) |>
      group_by(Sepal.Length > 5, .add = TRUE) |>
      count()
  )
  # overwrite existing column
  expect_equal(
    test_pl |>
      group_by(Sepal.Length = round(Sepal.Length)) |>
      count(),
    test_df |>
      group_by(Sepal.Length = round(Sepal.Length)) |>
      count()
  )
})

test_that("group_by() still accepts tidyselect calls with expressions", {
  # tidypolars-specific (dplyr requires pick() or across() for tidyselect)
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      group_by(starts_with("Spec"), Sepal.Length > 5) |>
      group_vars(),
    c("Species", "Sepal.Length > 5")
  )
})

test_that("group_by() with no variables clears groups", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> group_by(Species) |> group_by() |> group_vars(),
    test_df |> group_by(Species) |> group_by() |> group_vars()
  )
  expect_equal(
    test_pl |> group_by(Species) |> group_by() |> summarise(n = n()),
    test_df |> group_by(Species) |> group_by() |> summarise(n = n())
  )
  expect_equal(
    test_pl |> group_by(Species) |> group_by(.add = TRUE) |> group_vars(),
    test_df |> group_by(Species) |> group_by(.add = TRUE) |> group_vars()
  )
})
