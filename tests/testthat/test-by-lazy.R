### [GENERATED AUTOMATICALLY] Update test-by.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that(".by doesn't work on already grouped data", {
  test <- as_tibble(iris)
  test_pl <- as_polars_lf(test)

  expect_both_error(
    test_pl |> group_by(Species) |> mutate(foo = 1, .by = Species),
    test |> group_by(Species) |> mutate(foo = 1, .by = Species)
  )
  expect_snapshot_lazy(
    test_pl |> group_by(Species) |> mutate(foo = 1, .by = Species),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
