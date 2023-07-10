source("helpers.R")
using("tidypolars")

library(dplyr, warn.conflicts = FALSE)
library(stringr)

test_df <- data.frame(
  x1 = c("heLLo there", "it's mE"),
  x2 = c("apples x4", "bag of flour")
)

test <- pl$DataFrame(test_df)

for (i in c("toupper", "tolower", "str_to_lower", "str_to_upper")) {

  pol <- paste0("pl_mutate(test, foo = ", i, "(x1))") |>
    str2lang() |>
    eval() |>
    pl_pull(foo)

  res <- paste0("mutate(test_df, foo = ", i, "(x1))") |>
    str2lang() |>
    eval() |>
    pull(foo)

  expect_equal(pol, res, info = i)

}

expect_equal(
  pl_mutate(test, foo = str_starts(x1, "he")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_starts(x1, "he")) |>
    pull(foo)
)

expect_equal(
  pl_mutate(test, foo = str_starts(x1, "he", negate = TRUE)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_starts(x1, "he", negate = TRUE)) |>
    pull(foo)
)

expect_equal(
  pl_mutate(test, foo = str_ends(x1, "ere")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_ends(x1, "ere")) |>
    pull(foo)
)

expect_equal(
  pl_mutate(test, foo = str_ends(x1, "ere", negate = TRUE)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_ends(x1, "ere", negate = TRUE)) |>
    pull(foo)
)

expect_equal(
  pl_mutate(test, foo = str_extract(x2, "\\d")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_extract(x2, "\\d")) |>
    pull(foo)
)

expect_equal(
  pl_mutate(test, foo = str_extract(x2, "[a-z]+")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_extract(x2, "[a-z]+")) |>
    pull(foo)
)

expect_equal(
  pl_mutate(test, foo = str_extract(x2, "([a-z]+) of ([a-z]+)", group = 2)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_extract(x2, "([a-z]+) of ([a-z]+)", group = 2)) |>
    pull(foo)
)
