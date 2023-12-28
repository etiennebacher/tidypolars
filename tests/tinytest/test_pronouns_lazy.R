### [GENERATED AUTOMATICALLY] Update test_pronouns.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

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

Sys.setenv('TIDYPOLARS_TEST' = FALSE)