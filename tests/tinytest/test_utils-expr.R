source("helpers.R")
using("tidypolars")

exit_file("Still WIP")

pl_iris <- pl$DataFrame(iris)

expect_equal(
  build_polars_expr(
    pl_iris,
    list(x = str2lang("mean(Sepal.Length)"))
  ),
  list(
    out_expr = "data$agg((pl_mean(pl$col('Sepal.Length')))$alias('x'))",
    to_drop = NULL
  )
)

expect_equal(
  build_polars_expr(
    pl_iris,
    list(
      x = str2lang("mean(Sepal.Length)"),
      y = str2lang("sd(Sepal.Length, na.rm = TRUE)"),
      Petal.Length = NULL,
      foo = NULL
    )
  ),
  list(
    out_expr = "data$agg((pl_mean(pl$col('Sepal.Length')))$alias('x'), (pl_sd(pl$col('Sepal.Length'), na.rm = TRUE))$alias('y'))",
    to_drop = c("Petal.Length", "foo")
  )
)
