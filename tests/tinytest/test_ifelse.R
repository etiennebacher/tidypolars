source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  x3 = "hello"
)

expect_equal(
  test |>
    mutate(y = ifelse(x1 == 'a', "foo", "bar")) |>
    pull(y),
  c("foo", "foo", "bar", "foo", "bar")
)

# errors when different types
# different behavior than from classic R (e.g iris$Species == 1
# returns all FALSE)
# I think it's better like this because it forces the user to
# be clear about data types
expect_error(
  test |>
    mutate(y = ifelse(x1 == 1, "foo", "bar")),
  "cannot compare"
)

expect_equal(
  test |>
    mutate(y = ifelse(x1 == 'a', x3, x1)) |>
    pull(y),
  c("hello", "hello", "b", "hello", "c")
)

# same with dplyr::if_else()

expect_equal(
  test |>
    mutate(y = if_else(x1 == 'a', "foo", "bar")) |>
    pull(y),
  c("foo", "foo", "bar", "foo", "bar")
)

expect_error(
  test |>
    mutate(y = if_else(x1 == 1, "foo", "bar")),
  "cannot compare"
)

expect_equal(
  test |>
    mutate(y = if_else(x1 == 'a', x3, x1)) |>
    pull(y),
  c("hello", "hello", "b", "hello", "c")
)
