source("helpers.R")
using("tidypolars")

pl_iris_lazy <- pl$LazyFrame(iris)

expect_equal(
  fetch(pl_iris_lazy, n_rows = 30),
  iris[1:30, ],
  check.attributes = FALSE
)

expect_equal(
  pl_iris_lazy |>
    pl_filter(Sepal.Length > 7) |>
    fetch(n_rows = 30) |>
    nrow(),
  12
)

expect_error(
  fetch(pl$DataFrame(iris)),
  "can only be used on a LazyFrame"
)
