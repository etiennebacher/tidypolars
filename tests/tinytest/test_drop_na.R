source("helpers.R")
using("tidypolars")

tmp <- mtcars
tmp[1:3, "mpg"] <- NA
tmp[4, "hp"] <- NA
pl_tmp <- polars::pl$DataFrame(tmp)

expect_equal(
  pl_drop_na(pl_tmp, drat) |> nrow(),
  32
)

expect_equal(
  pl_drop_na(pl_tmp, hp) |> nrow(),
  31
)

expect_equal(
  pl_drop_na(pl_tmp, mpg) |> nrow(),
  29
)

expect_equal(
  pl_drop_na(pl_tmp, mpg, hp) |> nrow(),
  28
)

expect_error(
  pl_drop_na(pl_tmp, foo) |> nrow(),
  ""
)
