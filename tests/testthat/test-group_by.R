test_that("Arg `.drop` is not supported in group_by()", {
  expect_snapshot(
    iris |>
      as_polars_df() |>
      group_by(Species, .drop = FALSE),
    error = TRUE
  )
})
