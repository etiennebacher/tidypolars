source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(x = 1:3)

expect_equal(
  test |> mutate(y = lag(x)),
  test |> mutate(y = dplyr::lag(x))
)

expect_equal(
  test |> mutate(y = sum(x)),
  test |> mutate(y = base::sum(x))
)

# function exists but has no translation
expect_error(
  test |> mutate(y = data.table::shift(x)),
  "doesn't know how to translate this function: `data.table::shift\\(\\)"
)
