### [GENERATED AUTOMATICALLY] Update test_summarize.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$LazyFrame(iris)
pl_iris_g <- pl_iris |>
  pl_group_by(Species)

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

expect_error_lazy(
  pl_summarize(pl_iris, x = mean(Sepal.Length)) ,
  pattern = "only works on grouped data"
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)