### [GENERATED AUTOMATICALLY] Update test_slice.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$LazyFrame(iris)

expect_equal_lazy(
  pl_slice_head(pl_iris) |> to_r(),
  head(iris, n = 5),
  check.attributes = FALSE
)

expect_equal_lazy(
  pl_slice_tail(pl_iris) |> to_r(),
  tail(iris, n = 5),
  check.attributes = FALSE
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)