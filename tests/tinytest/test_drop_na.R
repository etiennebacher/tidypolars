source("helpers.R")
using("tidypolars")

tmp <- mtcars
tmp[1:3, "mpg"] <- NA
tmp[4, "hp"] <- NA
pl_tmp <- polars::pl$DataFrame(tmp)

expect_is_tidypolars(drop_na(pl_tmp, drat))

expect_dim(
  drop_na(pl_tmp, drat),
  c(32, 11)
)

expect_dim(
  drop_na(pl_tmp, hp),
  c(31, 11)
)

expect_dim(
  drop_na(pl_tmp, mpg),
  c(29, 11)
)

expect_dim(
  drop_na(pl_tmp, mpg, hp),
  c(28, 11)
)

expect_dim(
  drop_na(pl_tmp),
  c(28, 11)
)

expect_error(
  drop_na(pl_tmp, foo),
  "don't exist"
)

