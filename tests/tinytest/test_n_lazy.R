### [GENERATED AUTOMATICALLY] Update test_n.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- pl$LazyFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  x3 = 1:5
)

# basic ---------------

expect_equal_lazy(
  test |>
    summarize(n_obs = n()) |>
    pull(n_obs),
  5
)

# by group ---------------

expect_equal_lazy(
  test |>
    summarize(n_obs = n(), .by = x1) |>
    pull(n_obs) |>
    sort(decreasing = TRUE),
  c(3, 1, 1)
)

expect_equal_lazy(
  test |>
    group_by(x1) |>
    summarize(n_obs = n()) |>
    pull(n_obs) |>
    sort(decreasing = TRUE),
  c(3, 1, 1)
)

# use in computations ---------------

expect_equal_lazy(
  test |>
    group_by(x1) |>
    summarize(foo = mean(x3) / n()) |>
    pull(foo) |>
    sort(decreasing = TRUE),
  c(5, 3, 0.7777),
  tolerance = 0.001
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)