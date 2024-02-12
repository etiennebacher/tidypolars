source("helpers.R")
using("tidypolars")

pl_fish_encounters <- polars::pl$DataFrame(tidyr::fish_encounters)

out <- pl_fish_encounters |>
  pivot_wider(names_from = station, values_from = seen)

expect_is_tidypolars(out)

# basic checks

expect_equal(dim(out), c(19, 12))
expect_colnames(out, c("fish", "Release", "I80_1", "Lisbon", "Rstr", "Base_TD",
                       "BCE", "BCW", "BCE2", "BCW2", "MAE", "MAW"))


# check values

first <- slice_head(out, n = 5)

expect_equal(
  pull(first, I80_1),
  rep(1, 5)
)
expect_equal(
  pull(first, BCE2),
  c(1, 1, 1, NA, NA)
)

# names prefix

prefixed <- pl_fish_encounters |>
  pivot_wider(names_from = station, values_from = seen, names_prefix = "foo_") |>
  slice_head(n = 5)

expect_equal(
  names(prefixed)[11:12],
  c("foo_MAE", "foo_MAW")
)

expect_error(
  pl_fish_encounters |>
    pivot_wider(
      names_from = station,
      values_from = seen,
      names_prefix = c("foo1", "foo2")
    ),
  "must be of length 1"
)

# names sep

pl_us_rent_income <- polars::pl$DataFrame(tidyr::us_rent_income)

sep <- pl_us_rent_income |>
  pivot_wider(
    names_from = variable,
    names_sep = ".",
    values_from = c(estimate, moe)
  )

expect_equal(
  names(sep)[3:6],
  c("estimate.income", "estimate.rent", "moe.income", "moe.rent")
)

# fill values

filled <- pl_fish_encounters |>
  pivot_wider(names_from = station, values_from = seen, values_fill = 0) |>
  slice_head(n = 5)

expect_equal(
  pull(filled, I80_1),
  rep(1, 5)
)
expect_equal(
  pull(filled, BCE2),
  c(1, 1, 1, 0, 0)
)
