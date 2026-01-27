test_that(".by doesn't work on already grouped data", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  expect_both_error(
    test_pl |> group_by(Species) |> mutate(foo = 1, .by = Species),
    test |> group_by(Species) |> mutate(foo = 1, .by = Species)
  )
  expect_snapshot(
    test_pl |> group_by(Species) |> mutate(foo = 1, .by = Species),
    error = TRUE
  )
})
