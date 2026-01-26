test_that(".by doesn't work on already grouped data", {
  expect_snapshot(
    as_polars_df(iris) |> group_by(Species) |> mutate(foo = 1, .by = Species),
    error = TRUE
  )
})
