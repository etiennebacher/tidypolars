source("helpers.R")
using("tidypolars")

test <- as_polars(mtcars)

expect_colnames(
  test |> pl_relocate(hp, vs, .before = cyl),
  c("mpg", "hp", "vs", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "carb")
)

# moved to first positions if no .before or .after
expect_colnames(
  test |> pl_relocate(hp, vs),
  c("hp", "vs", "mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "carb")
)

# .before and .after can be quoted or unquoted
expect_colnames(
  test |> pl_relocate(hp, vs, .after = "gear"),
  c("mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "hp", "vs", "carb")
)

# select helpers are also available
expect_colnames(
  test |> pl_relocate(contains("[aeiouy]")),
  c("cyl", "disp", "drat", "qsec", "am", "gear", "carb", "mpg", "hp", "wt", "vs")
)

# errors
expect_error(
  test |> pl_relocate(mpg, .before = cyl, .after = drat),
  "not both"
)
expect_error(
  test |> pl_relocate(mpg, .before = foo),
  "doesn't exist"
)
expect_error(
  test |> pl_relocate(mpg, .after = foo),
  "doesn't exist"
)
