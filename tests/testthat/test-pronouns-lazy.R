### [GENERATED AUTOMATICALLY] Update test-pronouns.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("using dollar sign works", {
  test_df <- tibble(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  test_pl <- as_polars_lf(test_df)
  x <- 10

  expect_equal_lazy(
    test_pl |> mutate(foo = .env$x * .env$x),
    test_df |> mutate(foo = .env$x * .env$x)
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = .env$x * .data$x),
    test_df |> mutate(foo = .env$x * .data$x)
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = x * .data$x),
    test_df |> mutate(foo = x * .data$x)
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = .data$x * .data$x),
    test_df |> mutate(foo = .data$x * .data$x)
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = x * .env$x),
    test_df |> mutate(foo = x * .env$x)
  )

  expect_both_error(
    test_pl |> mutate(foo = x * .env$bar),
    test_df |> mutate(foo = x * .env$bar)
  )
  expect_snapshot_lazy(
    test_pl |> mutate(foo = x * .env$bar),
    error = TRUE
  )

  expect_both_error(
    test_pl |> mutate(foo = x * .data$bar),
    test_df |> mutate(foo = x * .data$bar)
  )
  expect_snapshot_lazy(
    test_pl |> mutate(foo = x * .data$bar),
    error = TRUE
  )
})

test_that("using [[ sign works", {
  test_df <- tibble(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  test_pl <- as_polars_lf(test_df)
  x <- 10

  expect_equal_lazy(
    test_pl |> mutate(foo = .env[["x"]] * .env[["x"]]),
    test_df |> mutate(foo = .env[["x"]] * .env[["x"]])
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = .env[["x"]] * .data[["x"]]),
    test_df |> mutate(foo = .env[["x"]] * .data[["x"]])
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = x * .data[["x"]]),
    test_df |> mutate(foo = x * .data[["x"]])
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = .data[["x"]] * .data[["x"]]),
    test_df |> mutate(foo = .data[["x"]] * .data[["x"]])
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = x * .env[["x"]]),
    test_df |> mutate(foo = x * .env[["x"]])
  )

  var_names <- c("x", "y")

  expect_equal_lazy(
    test_pl |> mutate(foo = .data[[var_names[1]]] * .data[[var_names[2]]]),
    test_df |> mutate(foo = .data[[var_names[1]]] * .data[[var_names[2]]])
  )

  expect_both_error(
    test_pl |> mutate(foo = x * .env[["bar"]]),
    test_df |> mutate(foo = x * .env[["bar"]])
  )
  expect_snapshot_lazy(
    test_pl |> mutate(foo = x * .env[["bar"]]),
    error = TRUE
  )

  expect_both_error(
    test_pl |> mutate(foo = x * .data[["bar"]]),
    test_df |> mutate(foo = x * .data[["bar"]])
  )
  expect_snapshot_lazy(
    test_pl |> mutate(foo = x * .data[["bar"]]),
    error = TRUE
  )
})

test_that("missing both signs works", {
  test_df <- tibble(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  test_pl <- as_polars_lf(test_df)
  x <- 10

  expect_equal_lazy(
    test_pl |> mutate(foo = .data$y * .env[["x"]]),
    test_df |> mutate(foo = .data$y * .env[["x"]])
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
