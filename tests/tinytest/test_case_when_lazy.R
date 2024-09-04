### [GENERATED AUTOMATICALLY] Update test_case_when.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- pl$LazyFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal_lazy(
  test |>
    mutate(
      y = case_when(
        x1 == 'a' ~ "foo",
        x2 == 3 ~ "bar",
        .default = "hi there"
      )
    ) |>
    pull(y),
  c("foo", "foo", "hi there", "foo", "hi there")
)

expect_equal_lazy(
  test |>
    mutate(
      y = case_when(
        x1 %in% 'a' ~ "foo",
        x2 == 3 ~ "bar",
        .default = "hi there"
      )
    ) |>
    pull(y),
  c("foo", "foo", "hi there", "foo", "hi there")
)

expect_equal_lazy(
  test |>
    mutate(
      y = case_when(
        x1 %in% 'a' & x2 == 2 ~ "foo",
        x2 == 3 ~ "bar",
        .default = "hi there"
      )
    ) |>
    pull(y),
  c("foo", "hi there", "hi there", "bar", "hi there")
)

# no default

expect_equal_lazy(
  test |>
    mutate(
      y = case_when(
        x1 == 'a' ~ "foo",
        x2 == 3 ~ "bar"
      )
    ) |>
    pull(y),
  c("foo", "foo", NA, "foo", NA)
)

# evaluation of external objects works

foo <<- "a"
foo2 <<- "b"

expect_equal_lazy(
  test |>
    mutate(y = case_when(x1 %in% foo ~ "foo", x1 %in% foo2 ~ "foo2", .default = x1)) |>
    pull(y),
  c("foo", "foo", "foo2", "foo", "c")
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)