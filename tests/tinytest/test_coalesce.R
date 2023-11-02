source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(
  a = c(1, NA, NA, NA),
  b = c(1, 2, NA, NA),
  c = c(5, NA, 3, NA)
)

expect_equal(
  test |> mutate(d = coalesce(a, b, c)) |> pl_pull(d),
  c(1, 2, 3, NA)
)

expect_equal(
  test |> mutate(d = coalesce(a, b, c, default = 10)) |> pl_pull(d),
  c(1, 2, 3, 10)
)

# convert all new column to string

test <- polars::pl$DataFrame(
  a = c(1, NA, NA, NA),
  b = c("1", "2", NA, NA),
  c = c(5, NA, 3, NA)
)

expect_equal(
  test |> mutate(d = coalesce(a, b, c)) |> pl_pull(d),
  c("1.0", "2", "3.0", NA)
)
