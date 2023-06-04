source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$DataFrame(iris)

expect_dim(
  pl_filter(pl_iris, Species == "setosa"),
  c(50, 5)
)

expect_dim(
  pl_filter(pl_iris, Sepal.Length < 5 & Species == "setosa"),
  c(20, 5)
)

expect_dim(
  pl_filter(pl_iris, Sepal.Length < 5, Species == "setosa"),
  c(20, 5)
)

expect_dim(
  pl_filter(pl_iris, Sepal.Length < 5 | Species == "setosa"),
  c(52, 5)
)

expect_dim(
  pl_filter(pl_iris, Sepal.Length < Sepal.Width + Petal.Length),
  c(115, 5)
)

