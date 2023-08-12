source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(mtcars)

expect_equal(
  make_unique_id(test, am, gear) |>
    pl_slice_head(3) |>
    pl_pull(hash) |>
    unique() |>
    length(),
  1
)

expect_colnames(
  make_unique_id(test, am, gear),
  c(test$columns, "hash")
)

expect_colnames(
  make_unique_id(test, am, gear, new_col = "foo"),
  c(test$columns, "foo")
)

expect_equal(
  make_unique_id(test) |>
    pl_pull(hash) |>
    unique() |>
    length(),
  32
)

mtcars2 <- mtcars
mtcars2$hash <- 1
test2 <- pl$DataFrame(mtcars2)

expect_error(
  make_unique_id(test2, am, gear),
  'Column "hash" already exists'
)

