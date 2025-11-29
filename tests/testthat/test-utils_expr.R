test_that("internally, expressions are correctly split in pools", {
  pl_iris <- as_polars_df(iris)

  result <-
    # nolint: duplicated_arguments
    translate_dots(
      pl_iris,

      x = Sepal.Length * 3,
      Petal.Length = Petal.Length / x,
      x = NULL,
      mean_pl = mean(Petal.Length),
      foo = Sepal.Width + Petal.Width,
      env = rlang::current_env(),
      caller = rlang::current_env()
    )
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

  expect_equal(names(x), "a")

  expect_true(result$pool_exprs_1$x$meta$eq(expected$pool_exprs_1$x))
  expect_true(result$pool_exprs_1$foo$meta$eq(expected$pool_exprs_1$foo))
  expect_true(
    result$pool_exprs_2$Petal.Length$meta$eq(expected$pool_exprs_2$Petal.Length)
  )

  result <-
    # nolint: duplicated_arguments
    translate_dots(
      pl_iris,
      x = 1,
      x = "a",
      x = NULL,
      env = rlang::current_env(),
      caller = rlang::current_env()
    )
  expected <- list(
    pool_exprs_1 = list(x = pl$lit(1)),
    pool_exprs_2 = list(x = pl$lit("a")),
    pool_exprs_3 = list(x = NULL)
  )
  expect_true(result$pool_exprs_1$x$meta$eq(expected$pool_exprs_1$x))
  expect_true(result$pool_exprs_2$x$meta$eq(expected$pool_exprs_2$x))
})

test_that("error messages when error in known function is good", {
  pl_iris <- as_polars_df(iris)
  expect_snapshot(
    pl_iris |> mutate(foo = min_rank()),
    error = TRUE
  )
  expect_snapshot(
    pl_iris |> mutate(foo = dplyr::min_rank()),
    error = TRUE
  )
})

test_that("doesn't error with missing variable in function call, #219", {
  pl_iris <- pl$DataFrame(x = 1)
  # only errors with filter()
  foobar <- function(x) {
    pl_iris |> filter(x == 1)
  }

  expect_equal(foobar(), pl_iris)
})
