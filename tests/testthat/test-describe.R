# TODO: uncomment when fixed in polars
# test_that("describe() is deprecated", {
#   test <- as_polars_df(mtcars)
#
#   expect_warning(
#     expect_equal(
#       describe(test) |>
#         pull(statistic),
#       c("count", "null_count", "mean", "std", "min", "25%", "50%", "75%", "max")
#     ),
#     "Please use `summary()` with the same arguments instead.",
#     fixed = TRUE
#   )
# })
