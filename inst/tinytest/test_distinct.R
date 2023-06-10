source("helpers.R")
using("tidypolars")

exit_if_not(packageVersion("polars") > "0.6.1")

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

expect_equal(
  pl_distinct(pl_test, iso_o) |>
    pl_pull(value),
  c(1, 3, 5)
)

expect_equal(
  pl_distinct(pl_test, iso_o, keep = "last") |>
    pl_pull(value),
  c(2, 4, 6)
)

expect_equal(
  pl_distinct(pl_test, iso_o, keep = "none") |> nrow(),
  0
)
