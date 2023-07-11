source("helpers.R")
using("tidypolars")

pl_fish_encounters <- polars::pl$DataFrame(fish_encounters)

out <- pl_fish_encounters |>
  pl_pivot_wider(names_from = station, values_from = seen)

# basic checks

expect_equal(dim(out), c(19, 12))
expect_colnames(out, c("fish", "Release", "I80_1", "Lisbon", "Rstr", "Base_TD",
                       "BCE", "BCW", "BCE2", "BCW2", "MAE", "MAW"))


# check values

first <- pl_slice_head(out)

expect_equal(
  pl_pull(first, I80_1),
  rep(1, 5)
)
expect_equal(
  pl_pull(first, BCE2),
  c(1, 1, 1, NA, NA)
)

# fill values

filled <- pl_fish_encounters |>
  pl_pivot_wider(names_from = station, values_from = seen, values_fill = 0) |>
  pl_slice_head()

expect_equal(
  pl_pull(filled, I80_1),
  rep(1, 5)
)
expect_equal(
  pl_pull(filled, BCE2),
  c(1, 1, 1, 0, 0)
)
