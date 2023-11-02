source("helpers.R")
using("tidypolars")

pl_test <- polars::pl$DataFrame(
  grp = rep(c("A", "B"), each = 3),
  x = c(NA, 1, NA, NA, 2, NA),
  y = c(3, NA, 4, NA, 3, 1)
)

expect_equal(
  pl_fill(pl_test, everything(), direction = "down") |>
    pull(x),
  c(NA, 1, 1, 1, 2, 2)
)

expect_equal(
  pl_fill(pl_test, everything(), direction = "down"),
  pl_fill(pl_test, x, y)
)

expect_equal(
  pl_fill(pl_test, everything(), direction = "updown") |>
    pull(x),
  c(1, 1, 2, 2, 2, 2)
)

expect_equal(
  pl_fill(pl_test, everything(), direction = "downup") |>
    pull(x),
  c(1, 1, 1, 1, 2, 2)
)

# grouped data

pl_grouped <- polars::pl$DataFrame(
  grp = rep(c("A", "B"), each = 3),
  x = c(NA, 1, NA, NA, 2, NA),
  y = c(3, NA, 4, NA, 3, 1)
) |>
  group_by(grp)

expect_equal(
  pl_fill(pl_grouped, everything(), direction = "down") |>
    pull(x),
  c(NA, 1, 1, NA, 2, 2)
)

expect_equal(
  pl_fill(pl_grouped, everything(), direction = "downup") |>
    pull(y),
  c(3, 3, 4, 3, 3, 1)
)

expect_equal(
  pl_fill(pl_grouped, everything(), direction = "updown") |>
    pull(y),
  c(3, 4, 4, 3, 3, 1)
)
