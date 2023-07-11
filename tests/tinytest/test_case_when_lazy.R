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


# TODO fix %in%
# expect_equal_lazy(
#   test |>
#     pl_mutate(
#       y = case_when(
#         x1 %in% 'a' ~ "foo",
#         x2 == 3 ~ "bar",
#         .default = "hi there"
#       )
#     ) |>
#     pl_pull(y),
#   c("foo", "foo", "hi there", "foo", "hi there")
# )


# no default

expect_equal_lazy(
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

Sys.setenv('TIDYPOLARS_TEST' = FALSE)