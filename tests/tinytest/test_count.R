source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(mtcars)

expect_equal(
  count(test) |> pl_pull(n),
  32
)

expect_equal(
  count(test, cyl) |> pl_pull(n),
  c(11, 7, 14)
)

expect_equal(
  count(test, cyl, am) |> pl_pull(n),
  c(3, 8, 4, 3, 12, 2)
)

expect_equal(
  count(test, cyl, am, sort = TRUE, name = "count") |> pl_pull(count),
  c(12, 8, 4, 3, 3, 2)
)

test_grp <- group_by(test, am)

expect_equal(
  count(test_grp) |> pl_pull(n),
  c(19, 13)
)

expect_equal(
  count(test_grp, cyl) |> pl_pull(n),
  c(3, 4, 12, 8, 3, 2)
)

expect_colnames(
  add_count(test, cyl),
  c(names(mtcars), "n")
)

expect_colnames(
  add_count(test, cyl, am, sort = TRUE, name = "count"),
  c(names(mtcars), "count")
)

expect_dim(
  add_count(test, cyl, am, sort = TRUE, name = "count"),
  c(32, 12)
)
