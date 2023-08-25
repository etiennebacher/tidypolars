source("helpers.R")
using("tidypolars")

expect_error(
  pl_arrange(mtcars, am),
  "must be a Polars DataFrame or LazyFrame"
)
