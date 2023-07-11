### [GENERATED AUTOMATICALLY] Update test_utils-expr.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

exit_file("Still WIP")

pl_iris <- pl$LazyFrame(iris)

expect_equal_lazy(
  build_polars_expr(
    pl_iris,
    list(x = str2lang("mean(Sepal.Length)"))
  ),
  list(
    out_expr = "data$agg((pl_mean(pl$col('Sepal.Length')))$alias('x'))",
    to_drop = NULL
  )
)

expect_equal_lazy(
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

Sys.setenv('TIDYPOLARS_TEST' = FALSE)