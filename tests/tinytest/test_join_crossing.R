source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(
  origin = c("ALG", "FRA", "GER"),
  year = c(2020, 2020, 2021)
)

test2 <- polars::pl$DataFrame(
  destination = c("USA", "JPN", "BRA"),
  language = c("english", "japanese", "portuguese")
)

expect_dim(
  pl_cross_join(test, test2),
  c(9, 4)
)

expect_equal(
  pl_cross_join(test, test2) |>
    pl_pull(origin),
  rep(c("ALG", "FRA", "GER"), each = 3)
)