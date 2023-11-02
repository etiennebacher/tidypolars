### [GENERATED AUTOMATICALLY] Update test_make_unique_id.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- pl$LazyFrame(mtcars)

expect_equal_lazy(
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

expect_equal_lazy(
  make_unique_id(test) |>
    pull(hash) |>
    unique() |>
    length(),
  32
)

mtcars2 <- mtcars
mtcars2$hash <- 1
test2 <- pl$LazyFrame(mtcars2)

expect_error_lazy(
  make_unique_id(test2, am, gear),
  'Column "hash" already exists'
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)