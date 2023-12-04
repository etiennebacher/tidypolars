source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(mtcars)

expect_equal(
  describe(test) |>
    pull(describe),
  c("count", "null_count", "mean", "std", "min", "max", "median", "25pct", "75pct")
)

expect_equal(
  describe(test, percentiles = c(0.2, 0.4)) |>
    pull(describe),
  c("count", "null_count", "mean", "std", "min", "max", "median", "20pct", "40pct")
)

expect_equal(
  describe(test, percentiles = c(0.2, 0.4, NULL)) |>
    pull(describe),
  c("count", "null_count", "mean", "std", "min", "max", "median", "20pct", "40pct")
)

expect_error(
  describe(test, percentiles = c(0.2, 0.4, NA)),
  'between 0 and 1'
)

expect_error(
  describe(test, percentiles = -1),
  'between 0 and 1'
)

expect_error(
  describe(test$lazy(), percentiles = 0.3),
  'only be used on a DataFrame'
)

