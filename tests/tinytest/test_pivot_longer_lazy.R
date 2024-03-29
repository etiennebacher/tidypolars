### [GENERATED AUTOMATICALLY] Update test_pivot_longer.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_relig_income <- polars::pl$LazyFrame(tidyr::relig_income)

out <- pl_relig_income |>
  pivot_longer(!religion, names_to = "income", values_to = "count")

expect_is_tidypolars(out)

# basic checks

expect_dim(out, c(180, 3))
expect_colnames(out, c("religion", "income", "count"))


# check values

first <- slice_head(out, n = 5)

expect_equal_lazy(
  pull(first, religion),
  rep("Agnostic", 5)
)

expect_equal_lazy(
  pull(first, income),
  c("<$10k", "$10-20k", "$20-30k", "$30-40k", "$40-50k"),
  skip_for_lazy = TRUE # sort() + slice_head() doesn't return the same output on
                       # LazyFrame (works with slice_tail())
)

expect_equal_lazy(
  pull(first, count),
  c(27, 34, 60, 81, 76),
  skip_for_lazy = TRUE # sort() + slice_head() doesn't return the same output on
                       # LazyFrame (works with slice_tail())
)


last <- slice_tail(out, n =5)

expect_equal_lazy(
  pull(last, religion),
  rep("Unaffiliated", 5)
)

expect_equal_lazy(
  pull(last, income),
  c("$50-75k", "$75-100k", "$100-150k", ">150k", "Don't know/refused")
)

expect_equal_lazy(
  pull(last, count),
  c(528, 407, 321, 258, 597)
)


# names_prefix

pl_billboard <- polars::pl$LazyFrame(tidyr::billboard)

expect_equal_lazy(
  pl_billboard |>
    pivot_longer(
      cols = starts_with("wk"),
      names_to = "week",
      names_prefix = "wk",
    ) |>
    arrange(artist, track, date.entered, week) |>
    head(3) |>
    pull(week),
  # polars and dplyr sort strings differently: for polars, "10" comes before "2"
  c("1", "10", "11")
)

expect_error_lazy(
  pl_billboard |>
    pivot_longer(
      cols = starts_with("wk"),
      names_to = "week",
      names_prefix = c("wk", "foo"),
    ),
  "must be of length 1"
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)