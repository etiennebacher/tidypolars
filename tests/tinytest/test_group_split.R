source("helpers.R")
using("tidypolars")

spl <- polars::pl$DataFrame(iris) |>
  group_split(Species)

expect_equal(length(spl), 3)
expect_equal(lapply(spl, nrow), list(50, 50, 50))


test <- polars::pl$DataFrame(iris) |>
  group_by(Species)

spl2 <- group_split(test)

expect_equal(length(spl2), 3)
expect_equal(lapply(spl2, nrow), list(50, 50, 50))


expect_warning(
  group_split(test, Sepal.Length),
  "is already grouped so variables"
)
