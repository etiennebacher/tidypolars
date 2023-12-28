source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))

x <- 10

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
