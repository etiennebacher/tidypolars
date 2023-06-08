source("helpers.R")
using("tidypolars")

exit_file("TODO")

test <- pl$DataFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal(
  pl_arrange(test, x1) |>
    pl_pull(x1) |>
    to_r(),
  c("a", "a", "a", "b", "c")
)

expect_equal(
  pl_arrange(test, -x1) |>
    pl_pull(x1) |>
    to_r(),
  c("c", "b", "a", "a", "a")
)

expect_equal(
  pl_arrange(test, -x1),
  pl_arrange(test, !x1)
)

expect_equal(
  pl_arrange(test, starts_with("x"))
)
