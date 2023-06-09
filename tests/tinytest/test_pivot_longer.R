source("helpers.R")
using("tidypolars")

pl_relig_income <- polars::pl$DataFrame(relig_income)

out <- pl_relig_income |>
  pl_pivot_longer(!religion, names_to = "income", values_to = "count")

# basic checks

expect_equal(dim(out), c(180, 3))
expect_colnames(out, c("religion", "income", "count"))


# check values

first <- pl_slice_head(out)

expect_equal(
  pl_pull(first, religion),
  rep("Agnostic", 5)
)

expect_equal(
  pl_pull(first, income),
  c("<$10k", "$10-20k", "$20-30k", "$30-40k", "$40-50k")
)

expect_equal(
  pl_pull(first, count),
  c(27, 34, 60, 81, 76)
)


last <- pl_slice_tail(out)

expect_equal(
  pl_pull(last, religion),
  rep("Unaffiliated", 5)
)

expect_equal(
  pl_pull(last, income),
  c("$50-75k", "$75-100k", "$100-150k", ">150k", "Don't know/refused")
)

expect_equal(
  pl_pull(last, count),
  c(528, 407, 321, 258, 597)
)

