source("helpers.R")
using("tidypolars")

tmp <- mtcars
tmp[1:3, "mpg"] <- NA
tmp[4, "hp"] <- NA
pl_tmp <- polars::pl$DataFrame(tmp)

expect_dim(
  pl_drop_na(pl_tmp, drat),
  c(32, 11)
)

expect_dim(
  pl_drop_na(pl_tmp, hp),
  c(31, 11)
)

expect_dim(
  pl_drop_na(pl_tmp, mpg),
  c(29, 11)
)

expect_dim(
  pl_drop_na(pl_tmp, mpg, hp),
  c(28, 11)
)

expect_error(
  pl_drop_na(pl_tmp, foo),
  ""
)
