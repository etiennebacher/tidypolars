### [GENERATED AUTOMATICALLY] Update test_ungroup.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- pl$LazyFrame(mtcars)

expect_equal_lazy(
  test |> group_by(am, cyl) |> ungroup(),
  test
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)