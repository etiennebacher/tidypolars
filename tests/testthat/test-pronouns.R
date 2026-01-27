test_that("using dollar sign works", {
  test <- tibble(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  test_pl <- as_polars_df(test)
  x <- 10

  expect_equal(
    test_pl |> mutate(foo = .env$x * .env$x),
    test |> mutate(foo = .env$x * .env$x)
  )

  expect_equal(
    test_pl |> mutate(foo = .env$x * .data$x),
    test |> mutate(foo = .env$x * .data$x)
  )

  expect_equal(
    test_pl |> mutate(foo = x * .data$x),
    test |> mutate(foo = x * .data$x)
  )

  expect_equal(
    test_pl |> mutate(foo = .data$x * .data$x),
    test |> mutate(foo = .data$x * .data$x)
  )

  expect_equal(
    test_pl |> mutate(foo = x * .env$x),
    test |> mutate(foo = x * .env$x)
  )

  expect_both_error(
    test_pl |> mutate(foo = x * .env$bar),
    test |> mutate(foo = x * .env$bar)
  )
  expect_snapshot(
    test_pl |> mutate(foo = x * .env$bar),
    error = TRUE
  )

  expect_both_error(
    test_pl |> mutate(foo = x * .data$bar),
    test |> mutate(foo = x * .data$bar)
  )
  expect_snapshot(
    test_pl |> mutate(foo = x * .data$bar),
    error = TRUE
  )
})

test_that("using [[ sign works", {
  test <- tibble(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  test_pl <- as_polars_df(test)
  x <- 10

  expect_equal(
    test_pl |> mutate(foo = .env[["x"]] * .env[["x"]]),
    test |> mutate(foo = .env[["x"]] * .env[["x"]])
  )

  expect_equal(
    test_pl |> mutate(foo = .env[["x"]] * .data[["x"]]),
    test |> mutate(foo = .env[["x"]] * .data[["x"]])
  )

  expect_equal(
    test_pl |> mutate(foo = x * .data[["x"]]),
    test |> mutate(foo = x * .data[["x"]])
  )

  expect_equal(
    test_pl |> mutate(foo = .data[["x"]] * .data[["x"]]),
    test |> mutate(foo = .data[["x"]] * .data[["x"]])
  )

  expect_equal(
    test_pl |> mutate(foo = x * .env[["x"]]),
    test |> mutate(foo = x * .env[["x"]])
  )

  var_names <- c("x", "y")

  expect_equal(
    test_pl |> mutate(foo = .data[[var_names[1]]] * .data[[var_names[2]]]),
    test |> mutate(foo = .data[[var_names[1]]] * .data[[var_names[2]]])
  )

  expect_both_error(
    test_pl |> mutate(foo = x * .env[["bar"]]),
    test |> mutate(foo = x * .env[["bar"]])
  )
  expect_snapshot(
    test_pl |> mutate(foo = x * .env[["bar"]]),
    error = TRUE
  )

  expect_both_error(
    test_pl |> mutate(foo = x * .data[["bar"]]),
    test |> mutate(foo = x * .data[["bar"]])
  )
  expect_snapshot(
    test_pl |> mutate(foo = x * .data[["bar"]]),
    error = TRUE
  )
})

test_that("missing both signs works", {
  test <- tibble(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  test_pl <- as_polars_df(test)
  x <- 10

  expect_equal(
    test_pl |> mutate(foo = .data$y * .env[["x"]]),
    test |> mutate(foo = .data$y * .env[["x"]])
  )
})
