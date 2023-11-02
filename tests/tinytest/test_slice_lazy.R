### [GENERATED AUTOMATICALLY] Update test_slice.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$LazyFrame(iris)

expect_equal_lazy(
  slice_head(pl_iris),
  head(iris, n = 5),
  check.attributes = FALSE
)

expect_equal_lazy(
  slice_tail(pl_iris),
  tail(iris, n = 5),
  check.attributes = FALSE
)

pl_iris_g <- pl_iris |>
  group_by(Species, maintain_order = TRUE)

hd <- slice_head(pl_iris_g, n = 2)

expect_equal_lazy(
  pull(hd, Species),
  factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
)

expect_dim(hd, c(6, 5))

expect_equal_lazy(
  pull(hd, Sepal.Length)[3:4],
  c(7, 6.4)
)


tl <- slice_tail(pl_iris_g, n = 2)

expect_equal_lazy(
  pull(tl, Species),
  factor(rep(c("setosa", "versicolor", "virginica"), each = 2))
)

expect_dim(tl, c(6, 5))

expect_equal_lazy(
  pull(tl, Sepal.Length)[3:4],
  c(5.1, 5.7)
)

# slice_sample ---------------------------------------------------

if (inherits(pl_iris, "DataFrame")) {
  expect_equal_lazy(
    slice_sample(pl_iris, n = 5) |> nrow(),
    5
  )

  expect_equal_lazy(
    slice_sample(pl_iris, prop = 0.1) |> nrow(),
    15
  )

  expect_error_lazy(
    slice_sample(pl_iris, n = 2, prop = 0.1),
    "not both"
  )

  expect_equal_lazy(
    slice_sample(pl_iris, n = 200, replace = TRUE) |> nrow(),
    200
  )

  expect_error_lazy(
    slice_sample(pl_iris, n = 200),
    "Cannot take more rows than"
  )

  expect_equal_lazy(
    slice_sample(pl_iris, prop = 2, replace = TRUE) |> nrow(),
    300
  )

  expect_error_lazy(
    slice_sample(pl_iris, prop = 1.2),
    "Cannot take more rows than"
  )

  expect_equal_lazy(
    pl_iris |>
      group_by(Species) |>
      slice_sample(n = 5) |>
      nrow(),
    15
  )

  expect_equal_lazy(
    pl_iris |>
      group_by(Species) |>
      slice_sample(prop = 0.1) |>
      nrow(),
    15
  )
}



Sys.setenv('TIDYPOLARS_TEST' = FALSE)
