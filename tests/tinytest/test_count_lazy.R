### [GENERATED AUTOMATICALLY] Update test_count.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(mtcars)

expect_equal_lazy(
  count(test) |> pull(n),
  32
)

expect_equal_lazy(
  count(test, cyl) |> pull(n),
  c(11, 7, 14)
)

expect_equal_lazy(
  count(test, cyl, am) |> pull(n),
  c(3, 8, 4, 3, 12, 2)
)

expect_equal_lazy(
  count(test, cyl, am, sort = TRUE, name = "count") |> pull(count),
  c(12, 8, 4, 3, 3, 2)
)

test_grp <- group_by(test, am)

expect_equal_lazy(
  count(test_grp) |> pull(n),
  c(19, 13)
)

expect_equal_lazy(
  count(test_grp, cyl) |> pull(n),
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

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
