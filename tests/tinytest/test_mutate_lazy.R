### [GENERATED AUTOMATICALLY] Update test_mutate.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$LazyFrame(iris)

# Basic ops: +, -, *, /

expect_equal_lazy(
  pl_mutate(pl_iris, x = Sepal.Width + Sepal.Length) |>
    pl_pull(x),
  iris$Sepal.Width + iris$Sepal.Length
)
expect_equal_lazy(
  pl_mutate(pl_iris, x = Sepal.Width - Sepal.Length + Petal.Length) |>
    pl_pull(x),
  iris$Sepal.Width - iris$Sepal.Length + iris$Petal.Length
)
expect_equal_lazy(
  pl_mutate(pl_iris, x = Sepal.Width*Sepal.Length) |>
    pl_pull(x),
  iris$Sepal.Width*iris$Sepal.Length
)
expect_equal_lazy(
  pl_mutate(pl_iris, x = Sepal.Width/Sepal.Length) |>
    pl_pull(x),
  iris$Sepal.Width/iris$Sepal.Length
)

# Logical ops

expect_equal_lazy(
  pl_mutate(pl_iris, x = Sepal.Width > Sepal.Length) |>
    pl_pull(x),
  iris$Sepal.Width > iris$Sepal.Length
)
expect_equal_lazy(
  pl_mutate(pl_iris, x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length) |>
    pl_pull(x),
  iris$Sepal.Width > iris$Sepal.Length & iris$Petal.Width > iris$Petal.Length
)

# %in% operator

test <- pl$LazyFrame(
  x1 = c("a", "a", "foo", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal_lazy(
  pl_mutate(test, x = x1 %in% letters) |>
    pl_pull(x),
  c(TRUE, TRUE, FALSE, TRUE, TRUE)
)

expect_equal_lazy(
  pl_mutate(test, x = x1 %in% letters & x2 < 3) |>
    pl_pull(x),
  c(TRUE, TRUE, FALSE, FALSE, TRUE)
)

# Overwrite existing vars

expect_equal_lazy(
  pl_mutate(pl_iris, Sepal.Width = Sepal.Width*2) |>
    pl_pull(Sepal.Width),
  iris$Sepal.Width*2
)

# Scalar

expect_equal_lazy(
  pl_mutate(pl_iris, Sepal.Width = 2) |>
    pl_pull(Sepal.Width) |>
    unique(),
  2
)

expect_equal_lazy(
  pl_mutate(pl_iris, Sepal.Width = "a") |>
    pl_pull(Sepal.Width) |>
    unique(),
  "a"
)

# Several exprs

out <- pl_mutate(
  pl_iris,
  Sepal.Width = Sepal.Width*2,
  Petal.Width = Petal.Width*3
)

expect_equal_lazy(
  c(
    pl_pull(out, Sepal.Width),
    pl_pull(out, Petal.Width)
  ),
  c(iris$Sepal.Width*2, iris$Petal.Width*3)
)

# grouped data (checked with dplyr)

out <- pl_iris |>
  pl_group_by(Species) |>
  pl_mutate(
    foo = mean(Sepal.Length)
  )

expect_equal_lazy(
  pl_pull(out, foo) |> unique(),
  c(5.006, 5.936, 6.588)
)

out <- polars::pl$LazyFrame(mtcars) |>
  pl_group_by(cyl, am) |>
  pl_mutate(
    disp2 = disp / mean(disp)
  ) |>
  pl_ungroup()

expect_equal_lazy(
  out |> pl_slice_head(5) |> pl_pull(disp2),
  c(1.032258, 1.032258, 1.153692, 1.261305, 1.006664),
  tolerance = 1e5
)

expect_colnames(
  pl_iris |>
    pl_group_by(Species) |>
    pl_mutate(Sepal.Length = NULL),
  names(iris)[2:5]
)


# warning

expect_warning(
  pl_mutate(pl_iris, foo = mean(Sepal.Length, na.rm = TRUE)),
  pattern = "Additional arguments will not be used"
)


# custom function that returns Polars expression

foo <<- function(x, y) {
  tmp <- x$mean()
  tmp2 <- y$mean()
  tmp + tmp2
}

expect_equal_lazy(
  pl_mutate(pl_iris, x = foo(Sepal.Length, Petal.Length)) |>
    pl_pull(x),
  rep(mean(iris$Sepal.Length) + mean(iris$Petal.Length), nrow(iris))
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)