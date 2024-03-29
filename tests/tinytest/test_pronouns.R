source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))

x <- 10

# with $ sign -------------------

expect_equal(
  test |>
    mutate(foo = .env$x * .env$x) |>
    pull(foo),
  rep(100, 3)
)

expect_equal(
  test |>
    mutate(foo = .env$x * .data$x) |>
    pull(foo),
  rep(10, 3)
)

expect_equal(
  test |>
    mutate(foo = x * .data$x) |>
    pull(foo),
  rep(1, 3)
)

expect_equal(
  test |>
    mutate(foo = .data$x * .data$x) |>
    pull(foo),
  rep(1, 3)
)

expect_equal(
  test |>
    mutate(foo = x * .env$x) |>
    pull(foo),
  rep(10, 3)
)

expect_error(
  test |> mutate(foo = x * .env$bar),
  "'bar' not found"
)

expect_error(
  test |> mutate(foo = x * .data$bar),
  "not found: bar"
)

# with [[ sign -------------------

expect_equal(
  test |>
    mutate(foo = .env[["x"]] * .env[["x"]]) |>
    pull(foo),
  rep(100, 3)
)

expect_equal(
  test |>
    mutate(foo = .env[["x"]] * .data[["x"]]) |>
    pull(foo),
  rep(10, 3)
)

expect_equal(
  test |>
    mutate(foo = x * .data[["x"]]) |>
    pull(foo),
  rep(1, 3)
)

expect_equal(
  test |>
    mutate(foo = .data[["x"]] * .data[["x"]]) |>
    pull(foo),
  rep(1, 3)
)

expect_equal(
  test |>
    mutate(foo = x * .env[["x"]]) |>
    pull(foo),
  rep(10, 3)
)

var_names <- c("x", "y")

expect_equal(
  test |>
    mutate(foo = .data[[var_names[1]]] * .data[[var_names[2]]]) |>
    pull(foo),
  c(4, 5, 6)
)

expect_error(
  test |> mutate(foo = x * .env[["bar"]]),
  "'bar' not found"
)

expect_error(
  test |> mutate(foo = x * .data[["bar"]]),
  "not found: bar"
)

# mixing both signs

expect_equal(
  test |>
    mutate(foo = .data$y * .env[["x"]]) |>
    pull(foo),
  c(40, 50, 60)
)
