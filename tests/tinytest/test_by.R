source("helpers.R")
using("tidypolars")

expect_error(
  as_polars(iris) |>
    group_by(Species) |>
    mutate(foo = 1, .by = Species),
  "Can't supply `.by` when `.data` is a grouped DataFrame or LazyFrame."
)
