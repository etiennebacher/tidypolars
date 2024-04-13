source("helpers.R")
using("tidypolars")

pl_mtcars <- polars::pl$DataFrame(mtcars)
pl_mtcars_lazy <- pl$LazyFrame(mtcars)

dest <- tempfile(fileext = ".parquet")

expect_error(
  sink_parquet(pl_mtcars, dest),
  "can only be used on a LazyFrame"
)

sink_parquet(pl_mtcars_lazy, dest)

expect_equal(
  polars::pl$scan_parquet(dest)$collect(),
  pl_mtcars
)
