source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(x = 1:3)

# with base
expect_equal(
  test |> mutate(y = sum(x)),
  test |> mutate(y = base::sum(x))
)

# with other pkgs
expect_equal(
  test |> mutate(y = lag(x)),
  test |> mutate(y = dplyr::lag(x))
)

expect_equal(
  test |> summarize(y = lag(x)),
  test |> summarize(y = dplyr::lag(x))
)

expect_equal(
  test |> filter(x == first(x)),
  test |> filter(x == dplyr::first(x))
)

# function exists but has no translation
expect_error(
  test |> mutate(y = data.table::shift(x)),
  "doesn't know how to translate this function: `data.table::shift()",
  fixed = TRUE
)

suppressPackageStartupMessages(library("data.table"))
expect_error(
  test |> mutate(y = year(x)),
  "doesn't know how to translate this function: `year()` (from package `data.table`)",
  fixed = TRUE
)
detach("package:data.table", unload = TRUE)

expect_error(
  test |> mutate(y = foobar(x)),
  "doesn't know how to translate this function: `foobar()`.",
  fixed = TRUE
)
