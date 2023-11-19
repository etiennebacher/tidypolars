### [GENERATED AUTOMATICALLY] Update test_by.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

expect_error_lazy(
  as_polars(iris) |>
    group_by(Species) |>
    mutate(foo = 1, .by = Species),
  "Can't supply `.by` when `.data` is a grouped DataFrame or LazyFrame."
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)