### [GENERATED AUTOMATICALLY] Update test_uncount.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))

expect_is_tidypolars(uncount(test, n))

expect_equal_lazy(
  uncount(test, n),
  polars::pl$LazyFrame(x = c("a", "b", "b"), y = c(100, 101, 101))
)

expect_equal_lazy(
  uncount(test, n, .id = "id"),
  polars::pl$LazyFrame(x = c("a", "b", "b"), y = c(100, 101, 101), id = c(1, 1, 2))
)

expect_equal_lazy(
  uncount(test, n, .remove = FALSE),
  polars::pl$LazyFrame(x = c("a", "b", "b"), y = c(100, 101, 101), n = c(1, 2, 2))
)

# with constant

expect_equal_lazy(
  uncount(test, 2),
  polars::pl$LazyFrame(x = c("a", "a", "b", "b"), y = c(100, 100, 101, 101), n = c(1, 1, 2, 2))
)

# with expression

expect_equal_lazy(
  uncount(test, 2 / n),
  polars::pl$LazyFrame(x = c("a", "a", "b"), y = c(100, 100, 101), n = c(1, 1, 2))
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)