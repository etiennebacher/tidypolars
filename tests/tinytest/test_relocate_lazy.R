### [GENERATED AUTOMATICALLY] Update test_relocate.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(mtcars)

expect_colnames(
  test |> pl_relocate(hp, vs, .before = cyl),
  c("mpg", "hp", "vs", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "carb")
)

expect_equal_lazy(
  pl_relocate(test),
  test
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
  test |> pl_relocate(matches("[aeiouy]")),
  c("cyl", "disp", "drat", "qsec", "am", "gear", "carb", "mpg", "hp", "wt", "vs")
)

# errors
expect_error_lazy(
  test |> pl_relocate(mpg, .before = cyl, .after = drat),
  "not both"
)
expect_error_lazy(
  test |> pl_relocate(mpg, .before = foo),
  ""
)
expect_error_lazy(
  test |> pl_relocate(mpg, .after = foo),
  ""
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)