source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(x = c(2, 2), y = c(2, 3), z = c(5, NA)) |>
  pl_rowwise()

expect_equal(
  test |>
    pl_mutate(m = mean(c(x, y, z))) |>
    pl_pull(m),
  c(3, 2.5)
)

expect_equal(
  test |>
    pl_mutate(m = min(c(x, y, z))) |>
    pl_pull(m),
  c(2, 2)
)

expect_equal(
  test |>
    pl_mutate(m = max(c(x, y, z))) |>
    pl_pull(m),
  c(5, 3)
)

test2 <- polars::pl$DataFrame(x = c(TRUE, TRUE), y = c(TRUE, FALSE), z = c(TRUE, NA)) |>
  pl_rowwise()

# TODO: uncomment this once r-polars has caught up py-polars
# expect_equal(
#   test |>
#     pl_mutate(m = all(c(x, y, z))) |>
#     pl_pull(m),
#   c(TRUE, FALSE)
# )
#
# expect_equal(
#   test |>
#     pl_mutate(m = any(c(x, y, z))) |>
#     pl_pull(m),
#   c(TRUE, TRUE)
# )
