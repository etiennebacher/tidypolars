source("helpers.R")
using("tidypolars")

pl_iris <- as_polars_df(iris)

expect_is_tidypolars(filter(pl_iris, Species == "setosa"))

expect_dim(
  filter(pl_iris, Species == "setosa"),
  c(50, 5)
)

expect_dim(
  filter(pl_iris, Sepal.Length < 5 & Species == "setosa"),
  c(20, 5)
)

expect_dim(
  filter(pl_iris, Sepal.Length < 5, Species == "setosa"),
  c(20, 5)
)

expect_dim(
  filter(pl_iris, Sepal.Length < 5 | Species == "setosa"),
  c(52, 5)
)

expect_dim(
  filter(pl_iris, Sepal.Length < Sepal.Width + Petal.Length),
  c(115, 5)
)

# Special filters

iris2 <- iris
iris2[c(3, 8, 58, 133), "Species"] <- NA
pl_iris_2 <- pl$DataFrame(iris2)

expect_dim(
  filter(pl_iris_2, is.na(Species)),
  c(4, 5)
)
expect_dim(
  filter(pl_iris_2, !is.na(Species)),
  c(146, 5)
)
expect_dim(
  filter(pl_iris_2, Species == "setosa", !is.na(Species)),
  c(48, 5)
)
expect_dim(
  filter(pl_iris_2, Species == "setosa" | is.na(Species)),
  c(52, 5)
)

iris2 <- iris
iris2[c(3, 8, 58, 133), "Sepal.Length"] <- NaN
pl_iris_2 <- pl$DataFrame(iris2)

expect_dim(
  filter(pl_iris_2, is.nan(Sepal.Length)),
  c(4, 5)
)
expect_dim(
  filter(pl_iris_2, !is.nan(Sepal.Length)),
  c(146, 5)
)
expect_dim(
  filter(pl_iris_2, Species == "setosa", !is.nan(Sepal.Length)),
  c(48, 5)
)
expect_dim(
  filter(pl_iris_2, Species == "setosa" | is.nan(Sepal.Length)),
  c(52, 5)
)

# %in% operator

pl_mtcars <- pl$DataFrame(mtcars)

expect_dim(
  filter(pl_mtcars, cyl %in% 4:5),
  c(11, 11)
)

expect_dim(
  filter(pl_mtcars, cyl %in% 4:5 & am %in% 1),
  c(8, 11)
)

expect_dim(
  filter(pl_mtcars, cyl %in% 4:5, am %in% 1),
  c(8, 11)
)

expect_dim(
  filter(pl_mtcars, cyl %in% 4:5 | am %in% 1),
  c(16, 11)
)

expect_dim(
  filter(pl_mtcars, cyl %in% 4:5, vs == 1),
  c(10, 11)
)

expect_dim(
  filter(pl_mtcars, cyl %in% 4:5 | carb == 4),
  c(21, 11)
)

expect_dim(
  iris |>
    as_polars_df() |>
    filter(Species %in% c("setosa", "virginica")),
  c(100, 5)
)

expect_dim(
  iris |>
    as_polars_df() |>
    filter(Species %in% c("setosa", "virginica")),
  c(100, 5)
)


# between()

expect_dim(
  filter(pl_iris, between(Sepal.Length, 5, 6)),
  c(67, 5)
)

expect_dim(
  filter(pl_iris, between(Sepal.Length, 5, 6), Species == "setosa"),
  c(30, 5)
)

# with grouped data

by_cyl <- polars::pl$DataFrame(mtcars) |>
  group_by(cyl, maintain_order = TRUE)

expect_equal(
  by_cyl |>
    filter(disp == max(disp)) |>
    pull(mpg),
  c(21.4, 24.4, 10.4)
)

expect_equal(
  as_polars_df(mtcars) |>
    filter(disp == max(disp), .by = cyl) |>
    pull(mpg),
  by_cyl |>
    filter(disp == max(disp)) |>
    pull(mpg)
)

expect_dim(
  as_polars_df(iris) |>
    group_by(Species) |>
    filter(Sepal.Length > median(Sepal.Length) | Petal.Width > 0.4),
  c(123, 5)
)

expect_dim(
  as_polars_df(iris) |>
    filter(Sepal.Length > median(Sepal.Length) | Petal.Width > 0.4,
           .by = Species),
  c(123, 5)
)

expect_equal(
  by_cyl |>
    filter(disp == max(disp)) |>
    attr("pl_grps"),
  "cyl"
)

expect_equal(
  by_cyl |>
    filter(disp == max(disp)) |>
    attr("maintain_grp_order"),
  TRUE
)

foo <- pl$DataFrame(
  grp = c("a", "a", "b", "b"),
  x = c(TRUE, TRUE, TRUE, FALSE)
)

expect_dim(
  foo |>
    group_by(grp) |>
    filter(all(x)),
  c(2, 2)
)

expect_dim(
  foo |>
    filter(all(x), .by = starts_with("g")),
  c(2, 2)
)

expect_dim(
  foo |>
    group_by(grp) |>
    filter(any(x)),
  c(4, 2)
)

expect_dim(
  foo |>
    filter(any(x), .by = starts_with("g")),
  c(4, 2)
)

expect_equal(
  foo |>
    filter(all(x), .by = starts_with("g")) |>
    attr("pl_grps"),
  NULL
)

expect_equal(
  foo |>
    filter(all(x), .by = starts_with("g")) |>
    attr("maintain_grp_order"),
  NULL
)

