source("helpers.R")
using("tidypolars")

pl_iris <- pl$DataFrame(iris)
pl_iris_lazy <- pl$LazyFrame(iris)

expect_equal(
  collect(pl_iris_lazy),
  pl_iris
)

expect_equal(
  pl_iris_lazy |>
    filter(Species == "setosa") |>
    collect(),
  pl_iris |>
    filter(Species == "setosa")
)

expect_error(
  collect(pl_iris),
  "no applicable method"
)
