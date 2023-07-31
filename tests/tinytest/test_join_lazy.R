### [GENERATED AUTOMATICALLY] Update test_join.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(
  x = c(1, 2, 3),
  y = c(1, 2, 3),
  z = c(1, 2, 3)
)

test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z2 = c(4, 5, 7)
)

expect_equal_lazy(
  test |>
    pl_left_join(test2),
  pl$LazyFrame(
    x = 1:3, y = 1:3,
    z = 1:3, z2 = c(4, 5, NA)
  )
)

expect_equal_lazy(
  test |>
    pl_right_join(test2),
  pl$LazyFrame(
    x = 1:2, y = 1:2,
    z = 1:2, z2 = c(4, 5)
  )
)

expect_equal_lazy(
  test |>
    pl_full_join(test2),
  pl$LazyFrame(
    x = c(1, 2, 3, 4), y = c(1, 2, 3, 4),
    z = c(1, 2, 3, NA), z2 = c(4, 5, NA, 7)
  )
)

expect_equal_lazy(
  test |>
    pl_inner_join(test2),
  pl$LazyFrame(
    x = c(1, 2), y = c(1, 2),
    z = c(1, 2), z2 = c(4, 5)
  )
)

# suffix

test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z = c(4, 5, 7)
)

expect_colnames(
  test |>
    pl_left_join(test2, by = c("x", "y")),
  c("x", "y", "z.x", "z.y")
)

expect_colnames(
  test |>
    pl_left_join(test2, by = c("x", "y"), suffix = c(".hi", ".hello")),
  c("x", "y", "z.hi", "z.hello")
)

expect_error_lazy(
  test |>
    pl_left_join(test2, by = c("x", "y"), suffix = c(".hi")),
  ""
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)