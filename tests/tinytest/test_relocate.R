source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(mtcars)

expect_is_tidypolars(relocate(test))
expect_is_tidypolars(relocate(test, hp, .before = cyl))

expect_colnames(
  test |> relocate(hp, vs, .before = cyl),
  c("mpg", "hp", "vs", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "carb")
)

expect_equal(
  relocate(test),
  test
)

# moved to first positions if no .before or .after
expect_colnames(
  test |> relocate(hp, vs),
  c("hp", "vs", "mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "carb")
)

# .before and .after can be quoted or unquoted
expect_colnames(
  test |> relocate(hp, vs, .after = "gear"),
  c("mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "hp", "vs", "carb")
)

# select helpers are also available
expect_colnames(
  test |> relocate(matches("[aeiouy]")),
  c("cyl", "disp", "drat", "qsec", "am", "gear", "carb", "mpg", "hp", "wt", "vs")
)

expect_colnames(
  test |> relocate(hp, vs, .after = last_col()),
  c("mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "carb", "hp", "vs")
)

expect_colnames(
  test |> relocate(hp, vs, .before = last_col()),
  c("mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "hp", "vs", "carb")
)

# errors
expect_error(
  test |> relocate(mpg, .before = cyl, .after = drat),
  "not both"
)
expect_error(
  test |> relocate(mpg, .before = foo),
  "don't exist"
)
expect_error(
  test |> relocate(mpg, .after = foo),
  "don't exist"
)
