source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  x3 = 1:5
)

# basic ---------------

expect_equal(
  test |>
    summarize(n_obs = n()) |>
    pull(n_obs),
  5
)

# by group ---------------

expect_equal(
  test |>
    summarize(n_obs = n(), .by = x1) |>
    pull(n_obs) |>
    sort(decreasing = TRUE),
  c(3, 1, 1)
)

expect_equal(
  test |>
    group_by(x1) |>
    summarize(n_obs = n()) |>
    pull(n_obs) |>
    sort(decreasing = TRUE),
  c(3, 1, 1)
)

# use in computations ---------------

expect_equal(
  test |>
    group_by(x1) |>
    summarize(foo = mean(x3) / n()) |>
    pull(foo) |>
    sort(decreasing = TRUE),
  c(5, 3, 0.7777),
  tolerance = 0.001
)
