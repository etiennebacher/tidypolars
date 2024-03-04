### [GENERATED AUTOMATICALLY] Update test_pull.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(mtcars)

expect_equal_lazy(
  pull(test, mpg),
  mtcars$mpg
)

expect_equal_lazy(
  pull(test, "mpg"),
  mtcars$mpg
)

expect_equal_lazy(
  pull(test, 1),
  mtcars$mpg
)

expect_error_lazy(
  pull(test, dplyr::all_of(c("mpg", "drat"))),
  "can only extract one column"
)

expect_error_lazy(
  pull(test, mpg, drat, hp)
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)