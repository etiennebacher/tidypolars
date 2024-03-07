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

# several columns in names_from

production <- expand.grid(
    product = c("A", "B"),
    country = c("AI", "EI"),
    year = 2000:2014
  ) |>
  filter((product == "A" & country == "AI") | product == "B") |>
  mutate(production = 1:45) |>
  as_polars_df()

wide <- production |>
  pivot_wider(
    names_from = c(product, country),
    values_from = production,
    names_sep = ".",
    names_prefix = "prod."
  )

expect_equal(
  wide |> slice_head(n = 1),
  data.frame(year = 2000, prod.A.AI = 1, prod.B.AI = 2, prod.B.EI = 3)
)

# names_glue

wide <- production |>
  pivot_wider(
    names_from = c(product, country),
    values_from = production,
    names_glue = "prod_{product}_{country}"
  )

expect_equal(
  wide |> slice_head(n = 1),
  data.frame(year = 2000, prod_A_AI = 1, prod_B_AI = 2, prod_B_EI = 3)
)

wide <- production |>
  pivot_wider(
    names_from = product,
    values_from = production,
    names_glue = "prod_{product}"
  )

expect_equal(
  wide |> slice_head(n = 2),
  data.frame(
    country = factor(c("AI", "EI")),
    year = c(2000, 2000),
    prod_A = c(1, NA),
    prod_B = c(2, 3)
  )
)

# error when overwriting existing column

df <- pl$DataFrame(
  a = c(1, 1),
  key = c("a", "b"),
  val = c(1, 2)
)

expect_error(pivot_wider(df, names_from = key, values_from = val))

# `names_from` must be supplied if `name` isn't in `data`

df <- pl$DataFrame(key = "x", val = 1)
expect_error(
  pivot_wider(df, values_from = val),
  "Column `name` doesn't exist"
)

# `values_from` must be supplied if `value` isn't in `data`

df <- pl$DataFrame(key = "x", val = 1)
expect_error(
  pivot_wider(df, names_from = key),
  "Column `value` doesn't exist"
)

# `names_from` must identify at least 1 column

df <- pl$DataFrame(key = "x", val = 1)
expect_error(
  pivot_wider(df, names_from = starts_with("foo"), values_from = val),
  "at least one variable in `names_from`"
)

# `values_from` must identify at least 1 column

df <- pl$DataFrame(key = "x", val = 1)
expect_error(
  pivot_wider(df, names_from = key, values_from = starts_with("foo")),
  "at least one variable in `values_from`"
)

# `id_cols = everything()` excludes `names_from` and `values_from`

df <- pl$DataFrame(key = "x", name = "a", value = 1L)
expect_equal(
  pivot_wider(df, id_cols = everything()),
  data.frame(key = "x", a = 1L)
)

# `id_cols` can't select columns from `names_from` or `values_from`

df <- pl$DataFrame(name = c("x", "y"), value = c(1, 2))
expect_error(pivot_wider(df, id_cols = name, names_from = name, values_from = value))
expect_error(pivot_wider(df, id_cols = value, names_from = name, values_from = value))
