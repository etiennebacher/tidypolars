### [GENERATED AUTOMATICALLY] Update test-pronouns.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("using dollar sign works", {
  test <- pl$LazyFrame(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  x <- 10

  expect_equal_lazy(
    test |>
      mutate(foo = .env$x * .env$x) |>
      pull(foo),
    rep(100, 3)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = .env$x * .data$x) |>
      pull(foo),
    rep(10, 3)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = x * .data$x) |>
      pull(foo),
    rep(1, 3)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = .data$x * .data$x) |>
      pull(foo),
    rep(1, 3)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = x * .env$x) |>
      pull(foo),
    rep(10, 3)
  )

  expect_snapshot_lazy(
    test |> mutate(foo = x * .env$bar),
    error = TRUE
  )

  expect_snapshot_lazy(
    test |> mutate(foo = x * .data$bar),
    error = TRUE
  )
})

test_that("using [[ sign works", {
  test <- pl$LazyFrame(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  x <- 10

  expect_equal_lazy(
    test |>
      mutate(foo = .env[["x"]] * .env[["x"]]) |>
      pull(foo),
    rep(100, 3)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = .env[["x"]] * .data[["x"]]) |>
      pull(foo),
    rep(10, 3)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = x * .data[["x"]]) |>
      pull(foo),
    rep(1, 3)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = .data[["x"]] * .data[["x"]]) |>
      pull(foo),
    rep(1, 3)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = x * .env[["x"]]) |>
      pull(foo),
    rep(10, 3)
  )

  var_names <- c("x", "y")

  expect_equal_lazy(
    test |>
      mutate(foo = .data[[var_names[1]]] * .data[[var_names[2]]]) |>
      pull(foo),
    c(4, 5, 6)
  )

  expect_snapshot_lazy(
    test |> mutate(foo = x * .env[["bar"]]),
    error = TRUE
  )

  expect_snapshot_lazy(
    test |> mutate(foo = x * .data[["bar"]]),
    error = TRUE
  )
})

test_that("missing both signs works", {
  test <- pl$LazyFrame(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  x <- 10
  expect_equal_lazy(
    test |>
      mutate(foo = .data$y * .env[["x"]]) |>
      pull(foo),
    c(40, 50, 60)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
