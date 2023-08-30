source("helpers.R")
using("tidypolars")

pl_iris_lazy <- pl$LazyFrame(iris)

expect_equal(
  pl_fetch(pl_iris_lazy, n_rows = 30),
  iris[1:30, ],
  check.attributes = FALSE
)

expect_equal(
  pl_iris_lazy |>
    pl_filter(Sepal.Length > 7) |>
    pl_fetch(n_rows = 30) |>
    nrow(),
  12
)

expect_error(
  pl_fetch(pl$DataFrame(iris)),
  "can only be used on a LazyFrame"
)
