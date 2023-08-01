source("helpers.R")
using("tidypolars")

# TODO: remove this when r-polars 0.8.0 is released
exit_if(is_ci())

test <- polars::pl$DataFrame(
  country = c("France", "France", "UK", "UK", "Spain"),
  year = c(2020, 2021, 2019, 2020, 2022),
  value = c(1, 2, 3, 4, 5)
)

expect_dim(
  pl_complete(test, country, year),
  c(12, 3)
)

expect_equal(
  pl_complete(test, country, year) |>
    pl_pull(country),
  rep(c("France", "Spain", "UK"), each = 4)
)

expect_equal(
  pl_complete(test, country, year) |>
    pl_slice_head(4) |>
    pl_pull(value),
  c(NA, 1, 2, NA)
)

expect_equal(
  pl_complete(test, country),
  test
)
