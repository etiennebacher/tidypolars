### [GENERATED AUTOMATICALLY] Update test_complete.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(
  country = c("France", "France", "UK", "UK", "Spain"),
  year = c(2020, 2021, 2019, 2020, 2022),
  value = c(1, 2, 3, 4, 5)
)

expect_dim(
  complete(test, country, year),
  c(12, 3)
)

expect_equal_lazy(
  complete(test, country, year) |>
    pull(country),
  rep(c("France", "Spain", "UK"), each = 4)
)

expect_equal_lazy(
  complete(test, country, year) |>
    slice_head(n = 4) |>
    pull(value),
  c(NA, 1, 2, NA)
)

expect_equal_lazy(
  complete(test, country, year, fill = list(value = 99)) |>
    slice_head(n = 4) |>
    pull(value),
  c(99, 1, 2, 99)
)

expect_equal_lazy(
  complete(test, country),
  test
)

# groups -------------------------------------------------------

# TODO: don't forget tests for groups

# levels <- c("a", "b", "c")
#
# df <- pl$LazyFrame(
#   g = c("a", "b", "a"),
#   a = c(1L, 1L, 2L),
#   b = factor(c("a", "a", "b"), levels = levels),
#   c = c(4, 5, 6)
# )
# gdf <- group_by(df, g)
# out <- complete(gdf, a, b)
#
#
# expect_identical(
#   out$data[[1]],
#   tibble(
#     a = vec_rep_each(c(1L, 2L), times = 3),
#     b = factor(vec_rep(c("a", "b", "c"), times = 2)),
#     c = c(4, NA, NA, NA, 6, NA)
#   )
# )
#
# expect_identical(
#   out$data[[2]],
#   tibble(
#     a = 1L,
#     b = factor(c("a", "b", "c")),
#     c = c(5, NA, NA)
#   )
# )


Sys.setenv('TIDYPOLARS_TEST' = FALSE)