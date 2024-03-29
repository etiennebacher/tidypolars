### [GENERATED AUTOMATICALLY] Update test_join_mutating.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

options(rlib_message_verbosity = "quiet")

test <- polars::pl$LazyFrame(
  x = c(1, 2, 3),
  y = c(1, 2, 3),
  z = c(1, 2, 3)
)

# No common variables

expect_error_lazy(
  left_join(test, polars::pl$LazyFrame(iris)),
  "`by` must be supplied when `x` and `y` have no common variables"
)

# check output

test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z2 = c(4, 5, 7)
)

expect_is_tidypolars(left_join(test, test2))
expect_is_tidypolars(right_join(test, test2))
expect_is_tidypolars(full_join(test, test2))
expect_is_tidypolars(inner_join(test, test2))

expect_equal_lazy(
  left_join(test, test2),
  pl$LazyFrame(
    x = 1:3, y = 1:3,
    z = 1:3, z2 = c(4, 5, NA)
  )
)

expect_equal_lazy(
  right_join(test, test2),
  pl$LazyFrame(
    x = c(1, 2, 4), y = c(1, 2, 4),
    z2 = c(4, 5, 7), z = c(1, 2, NA)
  )
)

expect_equal_lazy(
  full_join(test, test2),
  pl$LazyFrame(
    x = c(1, 2, 4, 3), y = c(1, 2, 4, 3),
    z = c(1, 2, NA, 3), z2 = c(4, 5, 7, NA)
  )
)

expect_equal_lazy(
  inner_join(test, test2),
  pl$LazyFrame(
    x = c(1, 2), y = c(1, 2),
    z = c(1, 2), z2 = c(4, 5)
  )
)

expect_warning(
  left_join(test, test2, keep = TRUE),
  "Unused arguments: keep"
)

expect_warning(
  left_join(test, test2, copy = TRUE),
  "Unused arguments: copy"
)

# different variable names to join by

test3 <- polars::pl$LazyFrame(
  x2 = c(1, 2, 4),
  y2 = c(1, 2, 4),
  z3 = c(4, 5, 7)
)

expect_equal_lazy(
  left_join(test, test3, join_by(x == x2, y == y2)),
  pl$LazyFrame(
    x = 1:3, y = 1:3,
    z = 1:3, z3 = c(4, 5, NA)
  )
)

expect_equal_lazy(
  left_join(test, test3, c("x" = "x2", "y" = "y2")),
  pl$LazyFrame(
    x = 1:3, y = 1:3,
    z = 1:3, z3 = c(4, 5, NA)
  )
)

# suffix

test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z = c(4, 5, 7)
)

expect_colnames(
  left_join(test, test2, by = c("x", "y")),
  c("x", "y", "z.x", "z.y")
)

expect_colnames(
  left_join(test, test2, by = c("x", "y"), suffix = c(".hi", ".hello")),
  c("x", "y", "z.hi", "z.hello")
)

expect_error_lazy(
  left_join(test, test2, by = c("x", "y"), suffix = c(".hi")),
  "must be of length 2"
)

# suffix + join_by

expect_colnames(
  left_join(test, test2, by = join_by(x, y)),
  c("x", "y", "z.x", "z.y")
)

expect_colnames(
  left_join(test, test2, by = join_by(x, y), suffix = c(".hi", ".hello")),
  c("x", "y", "z.hi", "z.hello")
)

expect_error_lazy(
  left_join(test, test2, by = join_by(x, y), suffix = c(".hi")),
  "must be of length 2"
)


# input class

if (Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
  Sys.setenv('TIDYPOLARS_TEST' = FALSE)
  exit_file("Manual exit")
}

test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z = c(4, 5, 7)
)

expect_error_lazy(
  left_join(test, iris),
  "must be either two DataFrames or two LazyFrames"
)

expect_equal_lazy(
  test2 |>
    mutate(foo = 1) |>  # adds class "tidypolars"
    left_join(test2) |>
    select(-foo),
  test2 |>
    left_join(test2)
)

options(rlib_message_verbosity = "default")

Sys.setenv('TIDYPOLARS_TEST' = FALSE)