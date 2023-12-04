### [GENERATED AUTOMATICALLY] Update test_separate.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- pl$LazyFrame(
  x = c(NA, "x.y", "x.z", "y.z")
)

expect_equal_lazy(
  separate(test, x, into = c("foo", "foo2"), sep = ".") |>
    pull(foo),
  c(NA, "x", "x", "y")
)

expect_equal_lazy(
  separate(test, x, into = c("foo", "foo2"), sep = ".") |>
    pull(foo2),
  c(NA, "y", "z", "z")
)


test2 <- pl$LazyFrame(
  x = c(NA, "x y", "x z", "y z")
)

# TODO: test more extensively regex
# https://github.com/pola-rs/polars/issues/4819
expect_equal_lazy(
  separate(test2, x, into = c("foo", "foo2")) |>
    pull(foo),
  c(NA, "x", "x", "y")
)

expect_equal_lazy(
  separate(test2, x, into = c("foo", "foo2")) |>
    pull(foo2),
  c(NA, "y", "z", "z")
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)