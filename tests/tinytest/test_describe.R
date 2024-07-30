source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(mtcars)

expect_warning(
  expect_equal(
    describe(test) |>
      pull(statistic),
    c("count", "null_count", "mean", "std", "min", "25%", "50%", "75%", "max")
  ),
  "Use `summary()` with the same arguments instead.",
  fixed = TRUE
)
