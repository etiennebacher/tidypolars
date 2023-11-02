### [GENERATED AUTOMATICALLY] Update test_replace_na.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_test <- pl$LazyFrame(x = c(NA, 1), y = c(2, NA))

expect_equal_lazy(
  replace_na(pl_test, 0) |>
    to_r(),
  data.frame(x = c(0, 1), y = c(2, 0))
)

expect_equal_lazy(
  replace_na(pl_test, list(x = 0, y = 999)) |>
    to_r(),
  data.frame(x = c(0, 1), y = c(2, 999))
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
