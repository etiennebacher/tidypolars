### [GENERATED AUTOMATICALLY] Update test_summarize.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$LazyFrame(iris)
pl_iris_g <- pl_iris |>
  pl_group_by(Species, maintain_order = TRUE)

expect_equal_lazy(
  pl_summarize(pl_iris_g, x = mean(Sepal.Length)) |>
    pl_pull(x),
  c(5.006, 5.936, 6.588)
)

expect_equal_lazy(
  pl_summarize(pl_iris_g,
               x = sum(Sepal.Length),
               y = mean(Sepal.Length)) |>
    pl_pull(y),
  c(5.006, 5.936, 6.588)
)

expect_equal_lazy(
  pl_summarize(pl_iris_g,
               x = 1) |>
    pl_pull(x),
  rep(1, 3)
)

expect_error_lazy(
  pl_summarize(pl_iris, x = mean(Sepal.Length)),
  pattern = "only works on grouped data"
)

expect_colnames(
  pl_summarize(pl_iris_g, Sepal.Length = NULL),
  names(iris)[2:5]
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)