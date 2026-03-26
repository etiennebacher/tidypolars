### [GENERATED AUTOMATICALLY] Update test-by.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that(".by doesn't work on already grouped data", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    test_pl |> group_by(Species) |> mutate(foo = 1, .by = Species),
    test_df |> group_by(Species) |> mutate(foo = 1, .by = Species)
  )
  expect_snapshot_lazy(
    test_pl |> group_by(Species) |> mutate(foo = 1, .by = Species),
    error = TRUE
  )

  expect_both_error(
    test_pl |> group_by(Species) |> filter(Sepal.Length > 5, .by = Species),
    test_df |> group_by(Species) |> filter(Sepal.Length > 5, .by = Species)
  )

  expect_both_error(
    test_pl |> group_by(Species) |> filter_out(Sepal.Length > 5, .by = Species),
    test_df |> group_by(Species) |> filter_out(Sepal.Length > 5, .by = Species)
  )

  expect_both_error(
    test_pl |> group_by(Species) |> fill(Sepal.Length, .by = Species),
    test_df |> group_by(Species) |> fill(Sepal.Length, .by = Species)
  )

  expect_both_error(
    test_pl |>
      group_by(Species) |>
      summarize(x = mean(Sepal.Length), .by = Species),
    test_df |>
      group_by(Species) |>
      summarize(x = mean(Sepal.Length), .by = Species)
  )

  expect_both_error(
    test_pl |> group_by(Species) |> slice_head(n = 2, by = Species),
    test_df |> group_by(Species) |> slice_head(n = 2, by = Species)
  )

  expect_both_error(
    test_pl |> group_by(Species) |> slice_tail(n = 2, by = Species),
    test_df |> group_by(Species) |> slice_tail(n = 2, by = Species)
  )

  expect_both_error(
    test_pl |> group_by(Species) |> slice_sample(n = 2, by = Species),
    test_df |> group_by(Species) |> slice_sample(n = 2, by = Species)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
