source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(mtcars)

expect_is_tidypolars(summary(test))

expect_equal(
  summary(test) |>
    pull(statistic),
  c("count", "null_count", "mean", "std", "min", "25%", "50%", "75%", "max")
)

expect_equal(
  summary(test, percentiles = c(0.2, 0.4)) |>
    pull(statistic),
  c("count", "null_count", "mean", "std", "min", "20%", "40%", "50%", "max")
)

expect_equal(
  summary(test, percentiles = c(0.2, 0.4, NULL)) |>
    pull(statistic),
  c("count", "null_count", "mean", "std", "min", "20%", "40%", "50%", "max")
)

expect_error(
  summary(test, percentiles = c(0.2, 0.4, NA)),
  'between 0 and 1'
)

expect_error(
  summary(test, percentiles = -1),
  'between 0 and 1'
)
