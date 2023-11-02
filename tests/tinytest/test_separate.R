source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(
  x = c(NA, "x.y", "x.z", "y.z")
)

expect_equal(
  pl_separate(test, x, into = c("foo", "foo2"), sep = ".") |>
    pull(foo),
  c(NA, "x", "x", "y")
)

expect_equal(
  pl_separate(test, x, into = c("foo", "foo2"), sep = ".") |>
    pull(foo2),
  c(NA, "y", "z", "z")
)


test2 <- pl$DataFrame(
  x = c(NA, "x y", "x z", "y z")
)

# TODO: test more extensively regex

# expect_equal(
#   pl_separate(test2, x, into = c("foo", "foo2")) |>
#     pull(foo) |>
#     to_r(),
#   c(NA, "x", "x", "y")
# )
#
# expect_equal(
#   pl_separate(test2, x, into = c("foo", "foo2")) |>
#     pull(foo2) |>
#     to_r(),
#   c(NA, "y", "z", "z")
# )
