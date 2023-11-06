source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(
  x = c(NA, "x.y", "x.z", "y.z")
)

expect_equal(
  separate(test, x, into = c("foo", "foo2"), sep = ".") |>
    pull(foo),
  c(NA, "x", "x", "y")
)

expect_equal(
  separate(test, x, into = c("foo", "foo2"), sep = ".") |>
    pull(foo2),
  c(NA, "y", "z", "z")
)


test2 <- pl$DataFrame(
  x = c(NA, "x y", "x z", "y z")
)

# TODO: test more extensively regex
# https://github.com/pola-rs/polars/issues/4819
expect_equal(
  separate(test2, x, into = c("foo", "foo2")) |>
    pull(foo),
  c(NA, "x", "x", "y")
)

expect_equal(
  separate(test2, x, into = c("foo", "foo2")) |>
    pull(foo2),
  c(NA, "y", "z", "z")
)
