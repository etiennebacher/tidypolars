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
expect_dim(
  pl_filter(pl_iris_2, Species == "setosa" | is.na(Species)),
  c(52, 5)
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
expect_dim(
  pl_filter(pl_iris_2, Species == "setosa" | is.nan(Sepal.Length)),
  c(52, 5)
)

# %in% operator

pl_mtcars <- pl$DataFrame(mtcars)

expect_dim(
  pl_filter(pl_mtcars, cyl %in% 4:5),
  c(11, 11)
)

expect_dim(
  pl_filter(pl_mtcars, cyl %in% 4:5 & am %in% 1),
  c(8, 11)
)

expect_dim(
  pl_filter(pl_mtcars, cyl %in% 4:5, am %in% 1),
  c(8, 11)
)

expect_dim(
  pl_filter(pl_mtcars, cyl %in% 4:5 | am %in% 1),
  c(16, 11)
)

expect_dim(
  pl_filter(pl_mtcars, cyl %in% 4:5, vs == 1),
  c(10, 11)
)

expect_dim(
  pl_filter(pl_mtcars, cyl %in% 4:5 | carb == 4),
  c(21, 11)
)

iris3 <- iris
iris3$Species <- as.character(iris3$Species)
pl_iris3 <- pl$DataFrame(iris3)

expect_dim(
  pl_filter(pl_iris3, Species %in% c("setosa", "virginica")),
  c(100, 5)
)

expect_dim(
  pl_filter(pl_iris3, Species %in% c("setosa", "foo")),
  c(50, 5)
)

# between()

expect_dim(
  pl_filter(pl_iris, between(Sepal.Length, 5, 6)),
  c(67, 5)
)

expect_dim(
  pl_filter(pl_iris, between(Sepal.Length, 5, 6), Species == "setosa"),
  c(30, 5)
)

expect_dim(
  pl_filter(pl_iris, between(Sepal.Length, 5, 6, include_bounds = FALSE)),
  c(51, 5)
)

# with grouped data

by_cyl <- mtcars |>
  as_polars() |>
  pl_group_by(cyl)

expect_equal(
  by_cyl |>
    pl_filter(disp == max(disp)) |>
    pl_pull(mpg),
  c(21.4, 24.4, 10.4)
)

