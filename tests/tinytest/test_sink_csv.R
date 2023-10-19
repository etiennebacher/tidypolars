source("helpers.R")
using("tidypolars")

pl_iris <- pl$DataFrame(iris)
pl_iris_lazy <- pl$LazyFrame(iris)

dest <- tempfile(fileext = ".csv")

expect_error(
  sink_csv(pl_iris, dest),
  "can only be used on a LazyFrame"
)

sink_csv(pl_iris_lazy, dest)

expect_equal(
  polars::pl$scan_csv(dest),
  pl_iris_lazy
)
