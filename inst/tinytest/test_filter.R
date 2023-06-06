source("helpers.R")
using("tidypolars")

pl_iris <- pl$DataFrame(iris)

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

# Special filters

iris2 <- iris
iris2[c(3, 8, 58, 133), "Species"] <- NA
pl_iris_2 <- pl$DataFrame(iris2)

expect_dim(
  pl_filter(pl_iris_2, is.na(Species)),
  c(4, 5)
)
expect_dim(
  pl_filter(pl_iris_2, !is.na(Species)),
  c(146, 5)
)
expect_dim(
  pl_filter(pl_iris_2, Species == "setosa", !is.na(Species)),
  c(48, 5)
)

iris2 <- iris
iris2[c(3, 8, 58, 133), "Sepal.Length"] <- NaN
pl_iris_2 <- pl$DataFrame(iris2)

expect_dim(
  pl_filter(pl_iris_2, is.nan(Sepal.Length)),
  c(4, 5)
)
expect_dim(
  pl_filter(pl_iris_2, !is.nan(Sepal.Length)),
  c(146, 5)
)
expect_dim(
  pl_filter(pl_iris_2, Species == "setosa", !is.nan(Sepal.Length)),
  c(48, 5)
)
