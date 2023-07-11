### [GENERATED AUTOMATICALLY] Update test_arrange.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- pl$LazyFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal_lazy(
  pl_arrange(test, x1) |>
    pl_pull(x1),
  c("a", "a", "a", "b", "c")
)

expect_equal_lazy(
  pl_arrange(test, -x1) |>
    pl_pull(x1),
  c("c", "b", "a", "a", "a")
)

expect_equal_lazy(
  pl_arrange(test, -x1),
  pl_arrange(test, !x1)
)

expect_equal_lazy(
  pl_arrange(test, x1, -x2) |>
    pl_select(starts_with("x")) |>
    to_r(),
  data.frame(
    x1 = c("a", "a", "a", "b", "c"),
    x2 = c(3, 2, 1, 5, 1)
  )
)

# vars don't exist

expect_equal_lazy(
  pl_arrange(test, foo, x1),
  pl_arrange(test, x1)
)

expect_equal_lazy(
  pl_arrange(test, foo),
  test
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)