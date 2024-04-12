source("helpers.R")
using("tidypolars")

exit_file("skip for now")

test <- polars::pl$DataFrame(mtcars)

expect_is_tidypolars(describe(test))

expect_equal(
  describe(test) |>
    pull(statistic),
  c("count", "null_count", "mean", "std", "min", "25%", "50%", "75%", "max")
)

expect_equal(
  describe(test, percentiles = c(0.2, 0.4)) |>
    pull(statistic),
  c("count", "null_count", "mean", "std", "min", "20%", "40%", "50%", "max")
)

expect_equal(
  describe(test, percentiles = c(0.2, 0.4, NULL)) |>
    pull(statistic),
  c("count", "null_count", "mean", "std", "min", "20%", "40%", "50%", "max")
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

