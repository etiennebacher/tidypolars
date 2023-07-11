source("helpers.R")
using("tidypolars")

exit_if_not(utils::packageVersion("polars") >= "0.6.2")

test <- polars::pl$DataFrame(mtcars)

expect_equal(
  pl_count(test) |> pl_pull(n),
  32
)

expect_equal(
  pl_count(test, cyl) |> pl_pull(n),
  c(11, 7, 14)
)

expect_equal(
  pl_count(test, cyl, am) |> pl_pull(n),
  c(3, 8, 4, 3, 12, 2)
)

expect_equal(
  pl_count(test, cyl, am, sort = TRUE, name = "count") |> pl_pull(count),
  c(12, 8, 4, 3, 3, 2)
)

expect_equal(
  pl_add_count(test, cyl, am, sort = TRUE, name = "count") |>
    pl_colnames(),
  c(names(mtcars), "count")
)

expect_equal(
  pl_add_count(test, cyl, am, sort = TRUE, name = "count") |>
    nrow(),
  32
)
