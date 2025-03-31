### [GENERATED AUTOMATICALLY] Update test-utils_expr.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("internally, expressions are correctly split in pools", {
  pl_iris <- as_polars_lf(iris)

  # flir-ignore-start
  result <- translate_dots(
    pl_iris,
    x = Sepal.Length * 3,
    Petal.Length = Petal.Length / x,
    x = NULL,
    mean_pl = mean(Petal.Length),
    foo = Sepal.Width + Petal.Width,
    env = rlang::current_env(),
    caller = rlang::current_env()
  )
  # flir-ignore-end
  expected <- list(
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
  )

  expect_true(result$pool_exprs_1$x$meta$eq(expected$pool_exprs_1$x))
  expect_true(result$pool_exprs_1$foo$meta$eq(expected$pool_exprs_1$foo))
  expect_true(
    result$pool_exprs_2$Petal.Length$meta$eq(expected$pool_exprs_2$Petal.Length)
  )

  # flir-ignore-start
  result <- translate_dots(
    pl_iris,
    x = 1,
    x = "a",
    x = NULL,
    env = rlang::current_env(),
    caller = rlang::current_env()
  )
  # flir-ignore-end
  expected <- list(
    pool_exprs_1 = list(x = pl$lit(1)),
    pool_exprs_2 = list(x = pl$lit("a")),
    pool_exprs_3 = list(x = NULL)
  )
  expect_true(result$pool_exprs_1$x$meta$eq(expected$pool_exprs_1$x))
  expect_true(result$pool_exprs_2$x$meta$eq(expected$pool_exprs_2$x))
})

test_that("error messages when error in known function is good", {
  pl_iris <- as_polars_lf(iris)
  expect_snapshot_lazy(
    pl_iris |> mutate(foo = min_rank()),
    error = TRUE
  )
  expect_snapshot_lazy(
    pl_iris |> mutate(foo = dplyr::min_rank()),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
