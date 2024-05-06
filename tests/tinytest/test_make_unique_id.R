source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(mtcars)

expect_is_tidypolars(make_unique_id(test, am, gear))

expect_equal(
  make_unique_id(test, am, gear) |>
    slice_head(n = 3) |>
    pull(hash) |>
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
    pull(hash) |>
    unique() |>
    length(),
  32
)

mtcars2 <- mtcars
mtcars2$hash <- 1
test2 <- polars::pl$DataFrame(mtcars2)

expect_error(
  make_unique_id(test2, am, gear),
  'Column "hash" already exists'
)

