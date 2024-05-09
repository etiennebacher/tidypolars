source("helpers.R")
using("tidypolars")

pl_test <- polars::pl$DataFrame(x = c(NA, 1), y = c(2, NA))

expect_is_tidypolars(replace_na(pl_test, 0))

expect_equal(
  replace_na(pl_test, 0),
  data.frame(x = c(0, 1), y = c(2, 0))
)

expect_equal(
  replace_na(pl_test, list(x = 0, y = 999)),
  data.frame(x = c(0, 1), y = c(2, 999))
)

expect_equal(
  pl_test |>
    mutate(x = replace_na(x, 0)) ,
  data.frame(x = c(0, 1), y = c(2, NA))
)
