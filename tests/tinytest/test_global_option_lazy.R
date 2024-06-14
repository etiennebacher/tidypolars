### [GENERATED AUTOMATICALLY] Update test_global_option.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(x = c(2, 1, 5, 3, 1))

expect_warning(
  test |> mutate(x2 = sample(x, prob = 0.5)),
  "tidypolars doesn't know how to use some arguments of `sample()`.",
  fixed = TRUE
)

options(tidypolars_unknown_args = "error")

expect_error_lazy(
  test |> mutate(x2 = sample(x, prob = 0.5)),
  "tidypolars doesn't know how to use some arguments of `sample()`: `prob`.",
  fixed = TRUE
)

options(tidypolars_unknown_args = "warn")

Sys.setenv('TIDYPOLARS_TEST' = FALSE)