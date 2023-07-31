### [GENERATED AUTOMATICALLY] Update test_ungroup.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- pl$LazyFrame(mtcars)

# TODO: uncomment this when https://github.com/pola-rs/r-polars/issues/338 is
# solved
# expect_equal_lazy(
#   test |> pl_group_by(am, cyl) |> pl_ungroup(),
#   test
# )

Sys.setenv('TIDYPOLARS_TEST' = FALSE)