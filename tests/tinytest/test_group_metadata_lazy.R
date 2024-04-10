### [GENERATED AUTOMATICALLY] Update test_group_metadata.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(
  x1 = c("a", "a", "b", "a", "c")
)

expect_equal_lazy(
  group_vars(test),
  character(0)
)

expect_equal_lazy(
  group_keys(test),
  data.frame()
)

test2 <- polars::pl$LazyFrame(mtcars) |>
  group_by(cyl, am)

expect_equal_lazy(
  group_vars(test2),
  c("cyl", "am")
)

expect_equal_lazy(
  group_keys(test2),
  data.frame(cyl = rep(c(4, 6, 8), each = 2L), am = rep(c(0, 1), 3))
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)