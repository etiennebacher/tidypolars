### [GENERATED AUTOMATICALLY] Update test_ungroup.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(mtcars)

expect_equal_lazy(
  test |> group_by(am, cyl) |> ungroup() |> attributes() |> length(),
  1
)

expect_equal_lazy(
  test |> rowwise(am, cyl) |> ungroup() |> attributes() |> length(),
  1
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)