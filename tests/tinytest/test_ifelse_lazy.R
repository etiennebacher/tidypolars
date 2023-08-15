### [GENERATED AUTOMATICALLY] Update test_ifelse.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- pl$LazyFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  x3 = "hello"
)

expect_equal_lazy(
  test |>
    pl_mutate(y = ifelse(x1 == 'a', "foo", "bar")) |>
    pl_pull(y),
  c("foo", "foo", "bar", "foo", "bar")
)

# errors when different types
# different behavior than from classic R (e.g iris$Species == 1
# returns all FALSE)
# I think it's better like this because it forces the user to
# be clear about data types
expect_error_lazy(
  test |>
    pl_mutate(y = ifelse(x1 == 1, "foo", "bar")),
  "cannot compare"
)

expect_equal_lazy(
  test |>
    pl_mutate(y = ifelse(x1 == 'a', x3, x1)) |>
    pl_pull(y),
  c("hello", "hello", "b", "hello", "c")
)

# same with dplyr::if_else()

expect_equal_lazy(
  test |>
    pl_mutate(y = if_else(x1 == 'a', "foo", "bar")) |>
    pl_pull(y),
  c("foo", "foo", "bar", "foo", "bar")
)

expect_error_lazy(
  test |>
    pl_mutate(y = if_else(x1 == 1, "foo", "bar")),
  "cannot compare"
)

expect_equal_lazy(
  test |>
    pl_mutate(y = if_else(x1 == 'a', x3, x1)) |>
    pl_pull(y),
  c("hello", "hello", "b", "hello", "c")
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)