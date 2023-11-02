### [GENERATED AUTOMATICALLY] Update test_coalesce.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(
  a = c(1, NA, NA, NA),
  b = c(1, 2, NA, NA),
  c = c(5, NA, 3, NA)
)

expect_equal_lazy(
  test |> mutate(d = coalesce(a, b, c)) |> pl_pull(d),
  c(1, 2, 3, NA)
)

expect_equal_lazy(
  test |> mutate(d = coalesce(a, b, c, default = 10)) |> pl_pull(d),
  c(1, 2, 3, 10)
)

# convert all new column to string

test <- polars::pl$LazyFrame(
  a = c(1, NA, NA, NA),
  b = c("1", "2", NA, NA),
  c = c(5, NA, 3, NA)
)

expect_equal_lazy(
  test |> mutate(d = coalesce(a, b, c)) |> pl_pull(d),
  c("1.0", "2", "3.0", NA)
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
