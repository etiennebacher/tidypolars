### [GENERATED AUTOMATICALLY] Update test_rowwise.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$LazyFrame(iris) |>
  pl_rowwise()


expect_equal_lazy(
  pl_mutate(pl_iris, x = mean(c(Petal.Length, Petal.Width, Sepal.Length, Sepal.Width))),
  iris$Sepal.Width + iris$Sepal.Length
)
expect_equal_lazy(
  pl_mutate(pl_iris, x = Sepal.Width - Sepal.Length + Petal.Length) |>
    pl_pull(x),
  iris$Sepal.Width - iris$Sepal.Length + iris$Petal.Length
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)