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
  pl_select(pl_iris, contains(".")),
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

# TODO: tinytest doesn't recognize rlang errors because they don't have the
# same structure
expect_error_lazy(
  pl_select(pl_iris, all_of(bad_selection)),
  ""
)

expect_colnames(
  pl_select(pl_iris, any_of(bad_selection)),
  c("Sepal.Length", "Sepal.Width")
)

expect_colnames(
  pl_select(pl_iris, where(is.numeric)),
  c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
)

expect_colnames(
  pl_select(pl_iris, where(is.factor)),
  "Species"
)

expect_error_lazy(
  pl_select(pl_iris, where(~ mean(.x) > 3.5)),
  "can only take `is.*` functions"
)

expect_colnames(
  pl_select(pl_iris, last_col(3)),
  "Sepal.Width"
)

expect_colnames(
  pl_select(pl_iris, 1:last_col(3)),
  c("Sepal.Length", "Sepal.Width")
)

test <- polars::pl$LazyFrame(
  x1 = "a", x2 = 1, x3 = "b", y = 2,
  x01 = "a", x02 = 1, x03 = "b"
)

expect_colnames(
  pl_select(test, num_range("x", 2:3)),
  c("x2", "x3")
)

expect_colnames(
  pl_select(test, num_range("x", 2:3, width = 2)),
  c("x02", "x03")
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)