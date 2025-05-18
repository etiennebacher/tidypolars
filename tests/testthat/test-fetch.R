# TODO: what to do with this?
# test_that("basic behavior works", {
#   pl_iris_lazy <- as_polars_lf(iris)
#
#   expect_is_tidypolars(fetch(pl_iris_lazy, n_rows = 30))
#
#   # TODO: droplevels() shouldn't be needed
#   expect_equal(
#     fetch(pl_iris_lazy, n_rows = 30) |>
#       as.data.frame() |>
#       droplevels(),
#     iris[1:30, ] |>
#       droplevels(),
#     ignore_attr = FALSE
#   )
#
#   expect_equal(
#     pl_iris_lazy |>
#       filter(Sepal.Length > 7) |>
#       fetch(n_rows = 30) |>
#       nrow(),
#     12
#   )
# })
#
# test_that("can only be used on LazyFrame", {
#   expect_snapshot(
#     fetch(as_polars_df(iris)),
#     error = TRUE
#   )
# })
