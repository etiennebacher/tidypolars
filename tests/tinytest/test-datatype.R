source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(x = NULL)

# Check that datatype NULL is correctly handled internally
expect_dim(
  test |> select(x),
  c(1, 1)
)

