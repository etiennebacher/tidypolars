### [GENERATED AUTOMATICALLY] Update test_ungroup.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- pl$LazyFrame(mtcars)

expect_equal_lazy(
  test |> pl_group_by(am, cyl) |> pl_ungroup(),
  test
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)