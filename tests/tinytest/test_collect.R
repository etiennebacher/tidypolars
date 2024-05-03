source("helpers.R")
using("tidypolars")

pl_iris <- pl$DataFrame(iris)
pl_iris_lazy <- pl$LazyFrame(iris)

expect_inherits(collect(pl_iris_lazy), "data.frame")

expect_equal(
  collect(pl_iris_lazy),
  iris
)

expect_equal(
  pl_iris_lazy |>
    filter(Species == "setosa") |>
    collect(),
  iris[iris$Species == "setosa", ],
  check.attributes = FALSE
)

expect_error(collect(pl_iris))
