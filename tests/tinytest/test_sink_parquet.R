source("helpers.R")
using("tidypolars")

pl_iris <- pl$DataFrame(iris)
pl_iris_lazy <- pl$LazyFrame(iris)

dest <- tempfile(fileext = ".parquet")

expect_error(
  sink_parquet(pl_iris, dest),
  "can only be used on a LazyFrame"
)

sink_parquet(pl_iris_lazy, dest)

# TODO: for some reason, collecting this scanned parquet crashes
# expect_equal(
#   polars::pl$scan_parquet(dest),
#   pl_iris_lazy
# )
