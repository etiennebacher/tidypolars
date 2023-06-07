source("helpers.R")
using("tidypolars")

expect_equal(
  rearrange_expr("mean(pl$col('Sepal.Length'))"),
  "(pl$col('Sepal.Length')$mean())"
)

expect_equal(
  rearrange_expr("mean(pl$col('Sepal.Length')) + sum(pl$col('Petal.Length'))"),
  "(pl$col('Sepal.Length')$mean() + pl$col('Petal.Length')$sum())"
)
