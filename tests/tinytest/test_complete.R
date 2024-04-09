source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(
  country = c("France", "France", "UK", "UK", "Spain"),
  year = c(2020, 2021, 2019, 2020, 2022),
  value = c(1, 2, 3, 4, 5)
)

expect_is_tidypolars(complete(test, country, year))

expect_dim(
  complete(test, country, year),
  c(12, 3)
)

expect_equal(
  complete(test, country, year) |>
    pull(country),
  rep(c("France", "Spain", "UK"), each = 4)
)

expect_equal(
  complete(test, country, year) |>
    slice_head(n = 4) |>
    pull(value),
  c(NA, 1, 2, NA)
)

expect_equal(
  complete(test, country, year, fill = list(value = 99)) |>
    slice_head(n = 4) |>
    pull(value),
  c(99, 1, 2, 99)
)

expect_equal(
  complete(test, country),
  test
)

# groups -------------------------------------------------------

df <- polars::pl$DataFrame(
  g = c("a", "b", "a"),
  a = c(1L, 1L, 2L),
  b = c("a", "a", "b"),
  c = c(4, 5, 6)
)
gdf <- group_by(df, g, maintain_order = TRUE)
out <- complete(gdf, a, b)

expect_equal(
  out,
  data.frame(
    g = c(rep("a", 4), "b"),
    a = c(1, 1, 2, 2, 1),
    b = c("a", "b", "a", "b", "a"),
    c = c(4, NA, NA, 6, 5)
  )
)

expect_equal(
  attr(out, "pl_grps"),
  "g"
)

expect_equal(
  attr(out, "maintain_grp_order"),
  TRUE
)
