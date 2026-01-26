test_that("basic behavior works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = 1:5
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> summarize(n_obs = n()),
    test |> summarize(n_obs = n())
  )
})

test_that("works with grouped data", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = 1:5
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |>
      summarize(n_obs = n(), .by = x1) |>
      arrange(x1),
    test |>
      summarize(n_obs = n(), .by = x1) |>
      arrange(x1)
  )

  expect_equal(
    test_pl |>
      group_by(x1) |>
      summarize(n_obs = n()) |>
      arrange(x1),
    test |>
      group_by(x1) |>
      summarize(n_obs = n()) |>
      arrange(x1)
  )
})

test_that("works in computation", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = 1:5
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |>
      group_by(x1) |>
      summarize(foo = mean(x3) / n()) |>
      arrange(x1),
    test |>
      group_by(x1) |>
      summarize(foo = mean(x3) / n()) |>
      arrange(x1)
  )
})
