### [GENERATED AUTOMATICALLY] Update test_join_mutating.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

options(rlib_message_verbosity = "quiet")

test <- polars::pl$LazyFrame(
  x = c(1, 2, 3),
  y = c(1, 2, 3),
  z = c(1, 2, 3)
)

# No common variables

expect_error_lazy(
  left_join(test, polars::pl$LazyFrame(iris)),
  "`by` must be supplied when `x` and `y` have no common variables"
)

# check output

test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z2 = c(4, 5, 7)
)

expect_is_tidypolars(left_join(test, test2))
expect_is_tidypolars(right_join(test, test2))
expect_is_tidypolars(full_join(test, test2))
expect_is_tidypolars(inner_join(test, test2))

expect_equal_lazy(
  left_join(test, test2),
  pl$LazyFrame(
    x = 1:3, y = 1:3,
    z = 1:3, z2 = c(4, 5, NA)
  )
)

expect_equal_lazy(
  right_join(test, test2),
  pl$LazyFrame(
    x = c(1, 2, 4), y = c(1, 2, 4),
    z2 = c(4, 5, 7), z = c(1, 2, NA)
  )
)

expect_equal_lazy(
  full_join(test, test2),
  pl$LazyFrame(
    x = c(1, 2, 4, 3), y = c(1, 2, 4, 3),
    z = c(1, 2, NA, 3), z2 = c(4, 5, 7, NA)
  )
)

expect_equal_lazy(
  inner_join(test, test2),
  pl$LazyFrame(
    x = c(1, 2), y = c(1, 2),
    z = c(1, 2), z2 = c(4, 5)
  )
)

expect_warning(
  left_join(test, test2, keep = TRUE),
  "Unused arguments: keep"
)

expect_warning(
  left_join(test, test2, copy = TRUE),
  "Unused arguments: copy"
)

# different variable names to join by

test3 <- polars::pl$LazyFrame(
  x2 = c(1, 2, 4),
  y2 = c(1, 2, 4),
  z3 = c(4, 5, 7)
)

expect_equal_lazy(
  left_join(test, test3, join_by(x == x2, y == y2)),
  pl$LazyFrame(
    x = 1:3, y = 1:3,
    z = 1:3, z3 = c(4, 5, NA)
  )
)

expect_equal_lazy(
  left_join(test, test3, c("x" = "x2", "y" = "y2")),
  pl$LazyFrame(
    x = 1:3, y = 1:3,
    z = 1:3, z3 = c(4, 5, NA)
  )
)

# suffix

test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z = c(4, 5, 7)
)

expect_colnames(
  left_join(test, test2, by = c("x", "y")),
  c("x", "y", "z.x", "z.y")
)

expect_colnames(
  left_join(test, test2, by = c("x", "y"), suffix = c(".hi", ".hello")),
  c("x", "y", "z.hi", "z.hello")
)

expect_error_lazy(
  left_join(test, test2, by = c("x", "y"), suffix = c(".hi")),
  "must be of length 2"
)

# suffix + join_by

expect_colnames(
  left_join(test, test2, by = join_by(x, y)),
  c("x", "y", "z.x", "z.y")
)

expect_colnames(
  left_join(test, test2, by = join_by(x, y), suffix = c(".hi", ".hello")),
  c("x", "y", "z.hi", "z.hello")
)

expect_error_lazy(
  left_join(test, test2, by = join_by(x, y), suffix = c(".hi")),
  "must be of length 2"
)

# argument "relationship"

expect_error_lazy(
  left_join(test, test2, by = join_by(x, y), relationship = "foo"),
  "must be one of"
)

country <- polars::pl$LazyFrame(
  iso = c("FRA", "DEU"),
  value = 1:2
)

country_year <- polars::pl$LazyFrame(
  iso = rep(c("FRA", "DEU"), each = 2),
  year = rep(2019:2020, 2),
  value2 = 3:6
)

for (i in c(left_join, full_join, inner_join)) {
  expect_error_lazy(
    do.call(i, list(country, country_year, join_by(iso), relationship = "one-to-one")),
    "did not fulfil 1:1 validation"
  )

  expect_error_lazy(
    do.call(i, list(country, country_year, join_by(iso), relationship = "many-to-one")),
    "did not fulfil m:1 validation"
  )
}

expect_error_lazy(
  right_join(country, country_year, join_by(iso), relationship = "one-to-one"),
  "did not fulfil 1:1 validation"
)

expect_error_lazy(
  right_join(country, country_year, join_by(iso), relationship = "one-to-many"),
  "did not fulfil 1:m validation"
)

expect_equal_lazy(
  left_join(country, country_year, join_by(iso), relationship = "one-to-many"),
  data.frame(
    iso = rep(c("FRA", "DEU"), each = 2),
    value = c(1, 1, 2, 2),
    year = rep(2019:2020, 2),
    value2 = 3:6
  )
)

expect_equal_lazy(
  left_join(country, country_year, join_by(iso), relationship = "many-to-many"),
  data.frame(
    iso = rep(c("FRA", "DEU"), each = 2),
    value = c(1, 1, 2, 2),
    year = rep(2019:2020, 2),
    value2 = 3:6
  )
)


# argument "na_matches"

pdf1 <- pl$LazyFrame(a = c(1, NA, NA, NaN), val = 1:4)
pdf2 <- pl$LazyFrame(a = c(1, 2, NA, NaN), val2 = 5:8)

expect_error_lazy(
  left_join(pdf1, pdf2, na_matches = "foo"),
  "must be one of"
)

expect_equal_lazy(
  left_join(pdf1, pdf2, "a") |>
    pull(val2),
  c(5, 7, 7, 8)
)

expect_equal_lazy(
  left_join(pdf1, pdf2, "a", na_matches = "never") |>
    pull(val2),
  c(5, NA, NA, 8)
)

# when doing full join, the result differs from dplyr because 1) row order is
# not the same (NA go at the end) and 2) NaN are matched anyway

expect_equal_lazy(
  full_join(pdf1, pdf2, "a") |>
    pull(a),
  c(1, 2, NA, NA, NaN)
)

expect_equal_lazy(
  full_join(pdf1, pdf2, "a", na_matches = "never") |>
    pull(a),
  c(1, 2, NA, NaN, NA, NA)
)


# input class

if (Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
  Sys.setenv('TIDYPOLARS_TEST' = FALSE)
  exit_file("Manual exit")
}

test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z = c(4, 5, 7)
)

expect_error_lazy(
  left_join(test, iris),
  "must be either two DataFrames or two LazyFrames"
)

expect_equal_lazy(
  test2 |>
    mutate(foo = 1) |>  # adds class "tidypolars"
    left_join(test2) |>
    select(-foo),
  test2 |>
    left_join(test2)
)

options(rlib_message_verbosity = "default")

Sys.setenv('TIDYPOLARS_TEST' = FALSE)