source("helpers.R")
using("tidypolars")

expect_error(
  arrange(mtcars, am),
  "must be a Polars DataFrame or LazyFrame"
)
