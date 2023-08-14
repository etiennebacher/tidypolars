source("helpers.R")
using("tidypolars")

pl_iris <- pl$DataFrame(iris)

expect_equal(
  translate_dots(
    pl_iris,
    x = Sepal.Length * 3,
    Petal.Length = Petal.Length / x,
    x = NULL,
    mean_pl = mean(Petal.Length),
    foo = Sepal.Width + Petal.Width
  ),
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
      mean_pl = pl_mean(pl$col("Petal.Length"))
    )
  )
)

expect_equal(
  translate_dots(
    pl_iris,
    x = 1,
    x = 2,
    x = NULL
  ),
  list(
    pool_exprs_1 = list(x = pl$lit(1)),
    pool_exprs_2 = list(x = pl$lit(2)),
    pool_exprs_3 = list(x = NULL)
  )
)

expect_equal(
  translate_dots(
    pl_iris,
    x = 1,
    x = "a",
    x = NULL
  ),
  list(
    pool_exprs_1 = list(x = pl$lit(1)),
    pool_exprs_2 = list(x = pl$lit("a")),
    pool_exprs_3 = list(x = NULL)
  )
)
