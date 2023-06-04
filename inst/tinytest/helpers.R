library(tinytest)

register_tinytest_extension(
  "tidypolars",
  c("expect_colnames", "expect_dim")
)


