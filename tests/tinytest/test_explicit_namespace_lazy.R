### [GENERATED AUTOMATICALLY] Update test_explicit_namespace.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(x = 1:3)

expect_equal_lazy(
  test |> mutate(y = lag(x)),
  test |> mutate(y = dplyr::lag(x))
)

expect_equal_lazy(
  test |> mutate(y = sum(x)),
  test |> mutate(y = base::sum(x))
)

# function exists but has no translation
expect_error_lazy(
  test |> mutate(y = data.table::shift(x)),
  "doesn't know how to translate this function: `data.table::shift\\(\\)"
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)