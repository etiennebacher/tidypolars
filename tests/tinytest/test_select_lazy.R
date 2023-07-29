### [GENERATED AUTOMATICALLY] Update test_select.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$LazyFrame(iris)

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

selection <- c("Sepal.Length", "Sepal.Width")

expect_colnames(
  pl_select(pl_iris, all_of(selection)),
  c("Sepal.Length", "Sepal.Width")
)

expect_colnames(
  pl_select(pl_iris, any_of(selection)),
  c("Sepal.Length", "Sepal.Width")
)

bad_selection <- c("Sepal.Length", "Sepal.Width", "foo")

expect_error_lazy(
  pl_select(pl_iris, all_of(bad_selection)),
  "do not correspond to any column names"
)

expect_colnames(
  pl_select(pl_iris, any_of(bad_selection)),
  c("Sepal.Length", "Sepal.Width")
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)