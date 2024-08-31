### [GENERATED AUTOMATICALLY] Update test-datatype.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(x = NULL)

# Check that datatype NULL is correctly handled internally
expect_dim(
  test |> select(x),
  c(1, 1)
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)