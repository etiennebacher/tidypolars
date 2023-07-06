source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal(
  test |>
    pl_mutate(
      y = case_when(
        x1 == 'a' ~ "foo",
        x2 == 3 ~ "bar",
        .default = "hi there"
      )
    ) |>
    pl_pull(y),
  c("foo", "foo", "hi there", "foo", "hi there")
)


# no default

expect_equal(
  test |>
    pl_mutate(
      y = case_when(
        x1 == 'a' ~ "foo",
        x2 == 3 ~ "bar"
      )
    ) |>
    pl_pull(y),
  c("foo", "foo", NA, "foo", NA)
)
