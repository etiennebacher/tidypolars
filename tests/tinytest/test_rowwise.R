source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$DataFrame(iris) |>
  pl_rowwise()


expect_equal(
  pl_mutate(pl_iris, x = mean(c(Petal.Length, Petal.Width, Sepal.Length, Sepal.Width))),
  iris$Sepal.Width + iris$Sepal.Length
)
expect_equal(
  pl_mutate(pl_iris, x = Sepal.Width - Sepal.Length + Petal.Length) |>
    pl_pull(x),
  iris$Sepal.Width - iris$Sepal.Length + iris$Petal.Length
)

