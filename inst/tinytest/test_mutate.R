source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$DataFrame(iris)

# Basic ops: +, -, *, /

expect_equal(
  pl_mutate(pl_iris, x = Sepal.Width + Sepal.Length) |>
    pl_pull(x),
  iris$Sepal.Width + iris$Sepal.Length
)
expect_equal(
  pl_mutate(pl_iris, x = Sepal.Width - Sepal.Length + Petal.Length) |>
    pl_pull(x),
  iris$Sepal.Width - iris$Sepal.Length + iris$Petal.Length
)
expect_equal(
  pl_mutate(pl_iris, x = Sepal.Width*Sepal.Length) |>
    pl_pull(x),
  iris$Sepal.Width*iris$Sepal.Length
)
expect_equal(
  pl_mutate(pl_iris, x = Sepal.Width/Sepal.Length) |>
    pl_pull(x),
  iris$Sepal.Width/iris$Sepal.Length
)

# Logical ops

expect_equal(
  pl_mutate(pl_iris, x = Sepal.Width > Sepal.Length) |>
    pl_pull(x),
  iris$Sepal.Width > iris$Sepal.Length
)
expect_equal(
  pl_mutate(pl_iris, x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length) |>
    pl_pull(x),
  iris$Sepal.Width > iris$Sepal.Length & iris$Petal.Width > iris$Petal.Length
)

# Overwrite existing vars

expect_equal(
  pl_mutate(pl_iris, Sepal.Width = Sepal.Width*2) |>
    pl_pull(Sepal.Width),
  iris$Sepal.Width*2
)

# Several exprs

out <- pl_mutate(
  pl_iris,
  Sepal.Width = Sepal.Width*2,
  Petal.Width = Petal.Width*3
)

expect_equal(
  c(
    pl_pull(out, Sepal.Width),
    pl_pull(out, Petal.Width)
  ),
  c(iris$Sepal.Width*2, iris$Petal.Width*3)
)
