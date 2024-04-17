### [GENERATED AUTOMATICALLY] Update test_funs_other.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test_df <- data.frame(
  x = c(1:4, 0:5, 11, 10),
  x_na = c(1:4, NA, 1:5, 11, 10),
  x_inf = c(1, Inf, 3:4, -Inf, 1:5, 11, 10)
)
test <- polars::pl$LazyFrame(test_df)

# which.min and which.max

expect_equal_lazy(
  test |>
    mutate(
      argmin = which.min(x),
      argmax = which.max(x),

      argmin_na = which.min(x_na),
      argmax_na = which.max(x_na),

      argmin_inf = which.min(x_inf),
      argmax_inf = which.max(x_inf)
    ),
  test_df |>
    mutate(
      argmin = which.min(x),
      argmax = which.max(x),

      argmin_na = which.min(x_na),
      argmax_na = which.max(x_na),

      argmin_inf = which.min(x_inf),
      argmax_inf = which.max(x_inf)
    )
)

# n_distinct

test <- polars::pl$LazyFrame(x = c("a", "a", "b", "b"), y = c(1:3, NA))

expect_error_lazy(
  test |>
    summarize(foo = n_distinct()),
  "must be supplied"
)

expect_equal_lazy(
  test |>
    summarize(foo = n_distinct(y)) |>
    pull(foo),
  4
)

expect_equal_lazy(
  test |>
    summarize(foo = n_distinct(y, na.rm = TRUE)) |>
    pull(foo),
  3
)

expect_equal_lazy(
  test |>
    summarize(foo = n_distinct(y, x)) |>
    pull(foo),
  4
)

expect_equal_lazy(
  test |>
    summarize(foo = n_distinct(y), .by = x) |>
    pull(foo),
  c(2, 2)
)

expect_equal_lazy(
  test |>
    summarize(foo = n_distinct(y, na.rm = TRUE), .by = x) |>
    pull(foo) |>
    sort(),
  c(1, 2)
)

# length

test <- pl$LazyFrame(x = c("a", "a", "a", "b", "b"), y = c(1:4, NA))

expect_equal_lazy(
  test |>
    mutate(foo = length(y)) |>
    pull(foo),
  rep(5, 5)
)

expect_equal_lazy(
  test |>
    mutate(foo = length(y), .by = x) |>
    pull(foo),
  c(3, 3, 3, 2, 2)
)

expect_equal_lazy(
  test |>
    mutate(foo = length(y), .by = c(x, y)) |>
    pull(foo),
  rep(1, 5)
)


# unique

test <- pl$LazyFrame(x = c("a", "a", "a", "b", "b"), y = c(2, 2, 3, 4, NA))

expect_error_lazy(
  test |>
    mutate(foo = unique(y)),
  "lengths don't match"
)

expect_equal_lazy(
  test |>
    mutate(foo = length(unique(y))) |>
    pull(foo),
  rep(4, 5)
)

expect_equal_lazy(
  test |>
    mutate(foo = length(unique(y)), .by = x) |>
    pull(foo),
  rep(2, 5)
)

expect_equal_lazy(
  test |>
    mutate(foo = length(unique(y)), .by = c(x, y)) |>
    pull(foo),
  rep(1, 5)
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)