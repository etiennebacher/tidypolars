source("helpers.R")
using("tidypolars")

pl_test <- pl$DataFrame(
  iso_o = rep(c("AA", "AB", "AC"), each = 2),
  iso_d = rep(c("BA", "BB", "BC"), each = 2),
  value = 1:6
)

expect_dim(
  distinct(pl_test),
  c(6, 3)
)

expect_dim(
  distinct(pl_test, iso_o),
  c(3, 3)
)

expect_equal(
  distinct(pl_test, iso_o) |>
    pull(value),
  c(1, 3, 5)
)

expect_equal(
  distinct(pl_test, iso_o, keep = "last") |>
    pull(value),
  c(2, 4, 6)
)

expect_dim(
  distinct(pl_test, iso_o, keep = "none"),
  c(0, 3)
)

pl_test <- pl$DataFrame(
  iso_o = c(rep(c("AA", "AB"), each = 2), "AC", "DC"),
  iso_d = rep(c("BA", "BB", "BC"), each = 2),
  value = c(2, 2, 3, 4, 5, 6)
)

expect_dim(
  duplicated_rows(pl_test),
  c(2, 3)
)

expect_dim(
  duplicated_rows(pl_test, iso_o, iso_d),
  c(4, 3)
)

expect_dim(
  duplicated_rows(pl_test, iso_d),
  c(6, 3)
)
