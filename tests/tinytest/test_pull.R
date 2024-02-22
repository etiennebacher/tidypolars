source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(mtcars)

expect_equal(
  pull(test, mpg),
  mtcars$mpg
)

expect_equal(
  pull(test, "mpg"),
  mtcars$mpg
)

expect_equal(
  pull(test, 1),
  mtcars$mpg
)
