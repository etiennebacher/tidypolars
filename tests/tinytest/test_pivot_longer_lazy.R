### [GENERATED AUTOMATICALLY] Update test_pivot_longer.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_relig_income <- polars::pl$LazyFrame(relig_income)

out <- pl_relig_income |>
  pl_pivot_longer(!religion, names_to = "income", values_to = "count")

# basic checks

expect_dim(out, c(180, 3))
expect_colnames(out, c("religion", "income", "count"))


# check values

first <- pl_slice_head(out)

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


last <- pl_slice_tail(out)

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


Sys.setenv('TIDYPOLARS_TEST' = FALSE)
