### [GENERATED AUTOMATICALLY] Update test_explicit_namespace.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(x = 1:3)

# with base
expect_equal_lazy(
  test |> mutate(y = sum(x)),
  test |> mutate(y = base::sum(x))
)

# with other pkgs
expect_equal_lazy(
  test |> mutate(y = lag(x)),
  test |> mutate(y = dplyr::lag(x))
)

expect_equal_lazy(
  test |> summarize(y = lag(x)),
  test |> summarize(y = dplyr::lag(x))
)

expect_equal_lazy(
  test |> filter(x == first(x)),
  test |> filter(x == dplyr::first(x))
)

# function exists but has no translation
expect_error_lazy(
  test |> mutate(y = data.table::shift(x)),
  "doesn't know how to translate this function: `data.table::shift\\(\\)"
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)