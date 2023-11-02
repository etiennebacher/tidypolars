### [GENERATED AUTOMATICALLY] Update test_join_filtering.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(
  x = c(1, 2, 3),
  y = c(1, 2, 3),
  z = c(1, 2, 3)
)
test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z2 = c(1, 2, 4)
)

expect_equal_lazy(
  semi_join(test, test2, by = c("x", "y")),
  pl$LazyFrame(
    x = c(1, 2), y = c(1, 2), z = c(1, 2)
  )
)

expect_equal_lazy(
  anti_join(test, test2, by = c("x", "y")),
  pl$LazyFrame(
    x = 3, y = 3, z = 3
  )
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
