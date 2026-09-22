test_that("Arg `.drop` is not supported in group_by()", {
  # tidypolars-specific (tidypolars doesn't support .drop argument)
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_snapshot(
    test_pl |> group_by(Species, .drop = FALSE),
    error = TRUE
  )
})

test_that("group_by() doesn't support named expressions, #233", {
  # tidypolars-specific (tidypolars doesn't support named expressions in group_by)
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_snapshot(
    test_pl |>
      group_by(is_present = !is.na(Sepal.Length)) |>
      count(),
    error = TRUE
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
