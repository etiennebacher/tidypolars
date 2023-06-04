source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$DataFrame(iris)

expect_colnames(
  pl_select(pl_iris, c("Sepal.Length", "Sepal.Width")),
  c("Sepal.Length", "Sepal.Width")
)

expect_colnames(
  pl_select(pl_iris, Sepal.Length, Sepal.Width),
  c("Sepal.Length", "Sepal.Width")
)

expect_colnames(
  pl_select(pl_iris, starts_with("Sepal")),
  c("Sepal.Length", "Sepal.Width")
)

expect_colnames(
  pl_select(pl_iris, ends_with("Length")),
  c("Sepal.Length", "Petal.Length")
)

expect_colnames(
  pl_select(pl_iris, contains("\\.")),
  c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
)

expect_colnames(
  pl_select(pl_iris, 1:4),
  c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
)

expect_colnames(
  pl_select(pl_iris, -5),
  c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
)
