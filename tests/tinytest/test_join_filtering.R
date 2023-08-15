source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(
  x = c(1, 2, 3),
  y = c(1, 2, 3),
  z = c(1, 2, 3)
)
test2 <- polars::pl$DataFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z2 = c(1, 2, 4)
)

expect_equal(
  pl_semi_join(test, test2, by = c("x", "y")),
  pl$DataFrame(
    x = c(1, 2), y = c(1, 2), z = c(1, 2)
  )
)

expect_equal(
  pl_anti_join(test, test2, by = c("x", "y")),
  pl$DataFrame(
    x = 3, y = 3, z = 3
  )
)
