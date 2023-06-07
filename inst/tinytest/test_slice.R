source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$DataFrame(iris)

expect_equal(
  pl_slice_head(pl_iris) |> to_r(),
  head(iris, n = 5)
)

expect_equal(
  pl_slice_tail(pl_iris) |> to_r(),
  tail(iris, n = 5)
)
