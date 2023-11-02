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

test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z2 = c(4, 5, 7)
)

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
  left_join(test, test2),
  "must be of the same class"
)

options(rlib_message_verbosity = "default")

Sys.setenv('TIDYPOLARS_TEST' = FALSE)