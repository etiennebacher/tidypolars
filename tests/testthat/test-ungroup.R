test_that("basic behavior works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> group_by(am, cyl) |> ungroup() |> attributes() |> length(),
    1
  )

  # rowwise returns different number of attributes (tidypolars has 1, tidyverse has more)
  expect_equal(
    test_pl |> rowwise(am, cyl) |> ungroup() |> group_vars(),
    test_df |> rowwise(am, cyl) |> ungroup() |> group_vars()
  )
})
