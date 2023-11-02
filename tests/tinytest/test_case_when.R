source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal(
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

expect_equal(
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

expect_equal(
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

expect_equal(
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
