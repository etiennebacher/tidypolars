library(tinytest)
library(polars)

register_tinytest_extension(
  "tidypolars",
  c("expect_colnames", "expect_dim")
)


