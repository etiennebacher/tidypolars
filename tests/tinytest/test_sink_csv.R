source("helpers.R")
using("tidypolars")

pl_mtcars <- polars::pl$DataFrame(mtcars)
pl_mtcars_lazy <- pl$LazyFrame(mtcars)

dest <- tempfile(fileext = ".csv")

expect_error(
  sink_csv(pl_mtcars, dest),
  "can only be used on a LazyFrame"
)

sink_csv(pl_mtcars_lazy, dest)

expect_equal(
  polars::pl$scan_csv(dest)$collect(),
  pl_mtcars
)
