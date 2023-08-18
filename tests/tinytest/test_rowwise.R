source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(x = 1:2, y = 3:4, z = 5:6) |>
  pl_rowwise()


expect_equal(
  test |>
    pl_mutate(m = mean(c(x, y, z))) |>
    pl_pull(m),
  c(3, 4)
)
