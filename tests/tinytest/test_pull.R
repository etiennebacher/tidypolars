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

expect_error(
  pull(test, dplyr::all_of(c("mpg", "drat"))),
  "can only extract one column"
)

expect_error(
  pull(test, mpg, drat, hp)
)
