### [GENERATED AUTOMATICALLY] Update test_drop_na.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

tmp <- mtcars
tmp[1:3, "mpg"] <- NA
tmp[4, "hp"] <- NA
pl_tmp <- polars::pl$LazyFrame(tmp)

expect_equal_lazy(
  pl_drop_na(pl_tmp, drat) |> nrow(),
  32
)

expect_equal_lazy(
  pl_drop_na(pl_tmp, hp) |> nrow(),
  31
)

expect_equal_lazy(
  pl_drop_na(pl_tmp, mpg) |> nrow(),
  29
)

expect_equal_lazy(
  pl_drop_na(pl_tmp, mpg, hp) |> nrow(),
  28
)

expect_error_lazy(
  pl_drop_na(pl_tmp, foo) |> nrow(),
  ""
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)