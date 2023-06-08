source("helpers.R")
using("tidypolars")

pl_test <- pl$DataFrame(
  iso_o = rep(c("AA", "AB", "AC"), each = 2),
  iso_d = rep(c("BA", "BB", "BC"), each = 2),
  value = 1:6
)

expect_equal(
  pl_distinct(pl_test) |> nrow(),
  6
)

expect_equal(
  pl_distinct(pl_test, iso_o) |> nrow(),
  3
)

# TODO: tests are hacky because order can change. Fix them when maintain_order
# is implemented

expect_equal(
  setdiff(
    pl_distinct(pl_test, iso_o) |>
      pl_pull(value) |>
      to_r(),
    c(1, 3, 5)
  ) |>
    length(),
  0
)

expect_equal(
  setdiff(
    pl_distinct(pl_test, iso_o, keep = "last") |>
      pl_pull(value) |>
      to_r(),
    c(2, 4, 6)
  ) |>
    length(),
  0
)

expect_equal(
  pl_distinct(pl_test, iso_o, keep = "none") |> nrow(),
  0
)
