test_that("Arg `.drop` is not supported in group_by()", {
  expect_snapshot(
    iris |>
      as_polars_df() |>
      group_by(Species, .drop = FALSE),
    error = TRUE
  )
})

test_that("group_by() doesn't support named expressions, #233", {
  expect_snapshot(
    iris |>
      as_polars_df() |>
      group_by(is_present = !is.na(Sepal.Length)) |>
      count(),
    error = TRUE
  )
})
