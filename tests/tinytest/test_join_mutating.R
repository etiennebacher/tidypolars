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
  pl_left_join(test, test2),
  pl$DataFrame(
    x = 1:3, y = 1:3,
    z = 1:3, z2 = c(4, 5, NA)
  )
)

expect_equal(
  pl_right_join(test, test2),
  pl$DataFrame(
    x = c(1, 2, 4), y = c(1, 2, 4),
    z2 = c(4, 5, 7), z = c(1, 2, NA)
  )
)

expect_equal(
  pl_full_join(test, test2),
  pl$DataFrame(
    x = c(1, 2, 4, 3), y = c(1, 2, 4, 3),
    z = c(1, 2, NA, 3), z2 = c(4, 5, 7, NA)
  )
)

expect_equal(
  pl_inner_join(test, test2),
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
  pl_left_join(test, test2, by = c("x", "y")),
  c("x", "y", "z.x", "z.y")
)

expect_colnames(
  pl_left_join(test, test2, by = c("x", "y"), suffix = c(".hi", ".hello")),
  c("x", "y", "z.hi", "z.hello")
)

expect_error(
  pl_left_join(test, test2, by = c("x", "y"), suffix = c(".hi")),
  ""
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

expect_error(
  pl_left_join(test, test2),
  ""
)

options(rlib_message_verbosity = "default")
