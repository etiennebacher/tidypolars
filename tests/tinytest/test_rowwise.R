source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(x = c(2, 2), y = c(2, 3), z = c(5, NA)) |>
  rowwise()

expect_equal(
  test |>
    mutate(m = mean(c(x, y, z))) |>
    pull(m),
  c(3, 2.5)
)

expect_equal(
  test |>
    mutate(m = min(c(x, y, z))) |>
    pull(m),
  c(2, 2)
)

expect_equal(
  test |>
    mutate(m = max(c(x, y, z))) |>
    pull(m),
  c(5, 3)
)

test2 <- polars::pl$DataFrame(x = c(TRUE, TRUE), y = c(TRUE, FALSE), z = c(TRUE, NA)) |>
  rowwise()

expect_equal(
  test2 |>
    mutate(m = all(c(x, y, z))) |>
    pull(m),
  c(TRUE, FALSE)
)

expect_equal(
  test2 |>
    mutate(m = any(c(x, y, z))) |>
    pull(m),
  c(TRUE, TRUE)
)
