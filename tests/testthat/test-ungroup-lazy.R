### [GENERATED AUTOMATICALLY] Update test-ungroup.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- as_polars_lf(mtcars)

  expect_equal_lazy(
    test |> group_by(am, cyl) |> ungroup() |> attributes() |> length(),
    1
  )
  expect_equal_lazy(
    test |> rowwise(am, cyl) |> ungroup() |> attributes() |> length(),
    1
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)