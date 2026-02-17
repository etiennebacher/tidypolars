### [GENERATED AUTOMATICALLY] Update test-n.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = 1:5
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> summarize(n_obs = n()),
    test_df |> summarize(n_obs = n())
  )
})

test_that("works with grouped data", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = 1:5
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      summarize(n_obs = n(), .by = x1) |>
      arrange(x1),
    test_df |>
      summarize(n_obs = n(), .by = x1) |>
      arrange(x1)
  )

  expect_equal_lazy(
    test_pl |>
      group_by(x1) |>
      summarize(n_obs = n()) |>
      arrange(x1),
    test_df |>
      group_by(x1) |>
      summarize(n_obs = n()) |>
      arrange(x1)
  )
})

test_that("works in computation", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = 1:5
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      group_by(x1) |>
      summarize(foo = mean(x3) / n()) |>
      arrange(x1),
    test_df |>
      group_by(x1) |>
      summarize(foo = mean(x3) / n()) |>
      arrange(x1)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
