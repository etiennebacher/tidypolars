### [GENERATED AUTOMATICALLY] Update test_case_match.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal_lazy(
  test |>
    mutate(
      y = case_match(
        x1,
        'a' ~ "foo",
        'b' ~ "bar",
        .default = "hi there"
      )
    ) |>
    pull(y),
  c("foo", "foo", "bar", "foo", "hi there")
)

expect_equal_lazy(
  test |>
    mutate(
      y = case_match(
        x1,
        c('a', 'c') ~ "foo",
        'b' ~ "bar"
      )
    ) |>
    pull(y),
  c("foo", "foo", "bar", "foo", "foo")
)

expect_equal_lazy(
  test |>
    mutate(
      y = case_match(
        x2,
        1:3 ~ "foo",
        .default = "bar"
      )
    ) |>
    pull(y),
  c("foo", "foo", "bar", "foo", "foo")
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)