source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$DataFrame(iris)
translate_dots <- tidypolars:::translate_dots

expect_equal(
  translate_dots(
    pl_iris,
    x = Sepal.Length * 3,
    Petal.Length = Petal.Length / x,
    x = NULL,
    mean_pl = mean(Petal.Length),
    foo = Sepal.Width + Petal.Width,
    env = rlang::current_env()
  ) |> rapply(remove_tidypolars_expr_class, how = "list"),
  list(
    pool_exprs_1 = list(
      x = pl$col("Sepal.Length") * 3,
      foo = pl$col("Sepal.Width") + pl$col("Petal.Width")
    ),
    pool_exprs_2 = list(
      Petal.Length = pl$col("Petal.Length") / pl$col("x"),
      x = NULL
    ),
    pool_exprs_3 = list(
      mean_pl = pl$col("Petal.Length")$mean()
    )
  ) |> rapply(remove_tidypolars_expr_class, how = "list")
)

expect_equal(
  translate_dots(
    pl_iris,
    x = 1,
    x = 2,
    x = NULL,
    env = rlang::current_env()
  ) |> rapply(remove_tidypolars_expr_class, how = "list"),
  list(
    pool_exprs_1 = list(x = pl$lit(1)),
    pool_exprs_2 = list(x = pl$lit(2)),
    pool_exprs_3 = list(x = NULL)
  ) |> rapply(remove_tidypolars_expr_class, how = "list")
)

expect_equal(
  translate_dots(
    pl_iris,
    x = 1,
    x = "a",
    x = NULL,
    env = rlang::current_env()
  ) |> rapply(remove_tidypolars_expr_class, how = "list"),
  list(
    pool_exprs_1 = list(x = pl$lit(1)),
    pool_exprs_2 = list(x = pl$lit("a")),
    pool_exprs_3 = list(x = NULL)
  ) |> rapply(remove_tidypolars_expr_class, how = "list")
)

expect_error(
  mutate(pl_iris, Sepal.Length = dplyr::lag(Sepal.Length)),
  "doesn't work when expressions contain"
)
