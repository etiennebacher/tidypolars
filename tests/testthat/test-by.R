test_that(".by doesn't work on already grouped data", {
  expect_error(
    as_polars_df(iris) |>
      group_by(Species) |>
      mutate(foo = 1, .by = Species),
    "Can't supply `.by` when `.data` is a grouped DataFrame or LazyFrame."
  )
})
