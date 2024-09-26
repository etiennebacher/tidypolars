### [GENERATED AUTOMATICALLY] Update test-utils_expr.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

# TODO: not sure that is useful
# test_that("internally, expressions are correctly split in pools", {
#   pl_iris <- pl$LazyFrame(iris)

#   expect_equal_lazy(
#     translate_dots(
#       pl_iris,
#       x = Sepal.Length * 3,
#       Petal.Length = Petal.Length / x,
#       x = NULL,
#       mean_pl = mean(Petal.Length),
#       foo = Sepal.Width + Petal.Width,
#       env = rlang::current_env(),
#       caller = rlang::current_env()
#     ),
#     list(
#       pool_exprs_1 = list(
#         x = pl$col("Sepal.Length") * 3,
#         foo = pl$col("Sepal.Width") + pl$col("Petal.Width")
#       ),
#       pool_exprs_2 = list(
#         Petal.Length = pl$col("Petal.Length") / pl$col("x"),
#         x = NULL
#       ),
#       pool_exprs_3 = list(
#         mean_pl = pl$col("Petal.Length")$mean()
#       )
#     )
#   )

#   expect_equal_lazy(
#     translate_dots(
#       pl_iris,
#       x = 1,
#       x = 2,
#       x = NULL,
#       env = rlang::current_env(),
#       caller = rlang::current_env()
#     ),
#     list(
#       pool_exprs_1 = list(x = pl$lit(1)),
#       pool_exprs_2 = list(x = pl$lit(2)),
#       pool_exprs_3 = list(x = NULL)
#     )
#   )

#   expect_equal_lazy(
#     translate_dots(
#       pl_iris,
#       x = 1,
#       x = "a",
#       x = NULL,
#       env = rlang::current_env(),
#       caller = rlang::current_env()
#     ),
#     list(
#       pool_exprs_1 = list(x = pl$lit(1)),
#       pool_exprs_2 = list(x = pl$lit("a")),
#       pool_exprs_3 = list(x = NULL)
#     )
#   )
# })

test_that("error messages when error in known function is good", {
  pl_iris <- pl$LazyFrame(iris)
  translate_dots <- tidypolars:::translate_dots

  expect_error_lazy(
    pl_iris |> mutate(foo = min_rank()),
    "Error while running function `min_rank()` in Polars.",
    fixed = TRUE
  )
  
  expect_error_lazy(
    pl_iris |> mutate(foo = dplyr::min_rank()),
    "Error while running function `dplyr::min_rank()` in Polars.",
    fixed = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)