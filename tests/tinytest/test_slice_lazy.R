### [GENERATED AUTOMATICALLY] Update test_slice.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$LazyFrame(iris)

expect_equal_lazy(
  pl_slice_head(pl_iris),
  head(iris, n = 5),
  check.attributes = FALSE
)

expect_equal_lazy(
  pl_slice_tail(pl_iris),
  tail(iris, n = 5),
  check.attributes = FALSE
)

pl_iris_g <- pl_iris |>
  pl_group_by(Species)

hd <- pl_slice_head(pl_iris_g, n = 2)

expect_equal_lazy(
  pl_pull(hd, Species),
  factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
)

expect_dim(hd, c(6, 5))

expect_equal_lazy(
  pl_pull(hd, Sepal.Length)[3:4],
  c(7, 6.4)
)


tl <- pl_slice_tail(pl_iris_g, n = 2)

expect_equal_lazy(
  pl_pull(tl, Species),
  factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
)

expect_dim(tl, c(6, 5))

expect_equal_lazy(
  pl_pull(tl, Sepal.Length)[3:4],
  c(5.1, 5.7)
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)