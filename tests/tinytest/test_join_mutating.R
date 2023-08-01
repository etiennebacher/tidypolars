source("helpers.R")
using("tidypolars")

options(rlib_message_verbosity = "quiet")

test <- polars::pl$DataFrame(
  x = c(1, 2, 3),
  y = c(1, 2, 3),
  z = c(1, 2, 3)
)

test2 <- polars::pl$DataFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z2 = c(4, 5, 7)
)

expect_equal(
  test |>
    pl_left_join(test2),
  pl$DataFrame(
    x = 1:3, y = 1:3,
    z = 1:3, z2 = c(4, 5, NA)
  )
)

expect_equal(
  test |>
    pl_right_join(test2),
  pl$DataFrame(
    x = 1:2, y = 1:2,
    z = 1:2, z2 = c(4, 5)
  )
)

expect_equal(
  test |>
    pl_full_join(test2),
  pl$DataFrame(
    x = c(1, 2, 3, 4), y = c(1, 2, 3, 4),
    z = c(1, 2, 3, NA), z2 = c(4, 5, NA, 7)
  )
)

expect_equal(
  test |>
    pl_inner_join(test2),
  pl$DataFrame(
    x = c(1, 2), y = c(1, 2),
    z = c(1, 2), z2 = c(4, 5)
  )
)

# suffix

test2 <- polars::pl$DataFrame(
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

expect_error(
  test |>
    pl_left_join(test2, by = c("x", "y"), suffix = c(".hi")),
  ""
)

options(rlib_message_verbosity = "default")
