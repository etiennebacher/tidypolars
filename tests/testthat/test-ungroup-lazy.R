### [GENERATED AUTOMATICALLY] Update test-ungroup.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> group_by(am, cyl) |> ungroup() |> attributes() |> length(),
    1
  )

  # rowwise returns different number of attributes (tidypolars has 1, tidyverse has more)
  expect_equal_lazy(
    test_pl |> rowwise(am, cyl) |> ungroup() |> group_vars(),
    test_df |> rowwise(am, cyl) |> ungroup() |> group_vars()
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
