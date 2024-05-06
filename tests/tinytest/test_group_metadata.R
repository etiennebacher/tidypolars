source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(
  x1 = c("a", "a", "b", "a", "c")
)

expect_equal(
  group_vars(test),
  character(0)
)

expect_equal(
  group_keys(test),
  data.frame()
)

test2 <- polars::pl$DataFrame(mtcars) |>
  group_by(cyl, am)

expect_equal(
  group_vars(test2),
  c("cyl", "am")
)

expect_equal(
  group_keys(test2),
  data.frame(cyl = rep(c(4, 6, 8), each = 2L), am = rep(c(0, 1), 3))
)
