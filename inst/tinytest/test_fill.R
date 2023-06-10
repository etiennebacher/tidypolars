source("helpers.R")
using("tidypolars")

pl_test <- polars::pl$DataFrame(
  grp = rep(c("A", "B"), each = 3),
  x = c(NA, 1, NA, NA, 2, NA),
  y = c(3, NA, 4, NA, 3, 1)
)

expect_equal(
  pl_fill(pl_test, everything(), direction = "down") |>
    pl_pull(x),
  c(NA, 1, 1, 1, 2, 2)
)

expect_equal(
  pl_fill(pl_test, everything(), direction = "down"),
  pl_fill(pl_test, x, y)
)

expect_equal(
  pl_fill(pl_test, everything(), direction = "updown") |>
    pl_pull(x),
  c(1, 1, 2, 2, 2, 2)
)

expect_equal(
  pl_fill(pl_test, everything(), direction = "downup") |>
    pl_pull(x),
  c(1, 1, 1, 1, 2, 2)
)

# grouped data

# TODO: the problem for now is that removing attributes does it even without
# reassigning the dataset.
# So in the example below, the first pl_fill() works like it should but not the
# second one because the data is back to a DataFrame

# pl_grouped <- polars::pl$DataFrame(
#   grp = rep(c("A", "B"), each = 3),
#   x = c(NA, 1, NA, NA, 2, NA),
#   y = c(3, NA, 4, NA, 3, 1)
# ) |>
#   pl_group_by(grp)
#
# expect_equal(
#   pl_fill(pl_grouped, everything(), direction = "down") |>
#     pl_pull(x),
#   c(NA, 1, 1, NA, 2, 2)
# )
