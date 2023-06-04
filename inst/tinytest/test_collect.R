source("helpers.R")
using("tidypolars")

pl_iris <- pl$DataFrame(iris)
pl_iris_lazy <- pl$DataFrame(iris)$lazy()

expect_equal(
  pl_collect(pl_iris_lazy),
  pl_iris
)

expect_equal(
  pl_iris_lazy |>
    pl_filter(Species == "setosa") |>
    pl_collect(),
  pl_iris |>
    pl_filter(Species == "setosa")
)

expect_error(
  pl_collect(pl_iris),
  "can only be used on a LazyFrame"
)
