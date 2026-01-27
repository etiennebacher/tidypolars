test_that("works with ungrouped data", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  spl_pl <- test_pl |> group_split(Species)
  spl <- test |> group_split(Species)

  expect_length(spl_pl, length(spl))
  expect_equal(lapply(spl_pl, nrow), lapply(spl, nrow))
})

test_that("works with when split variables and group variables are the same", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  test_grp <- test |> group_by(Species)
  test_pl_grp <- test_pl |> group_by(Species)

  spl_pl <- group_split(test_pl_grp)
  spl <- group_split(test_grp)

  expect_length(spl_pl, length(spl))
  expect_equal(lapply(spl_pl, nrow), lapply(spl, nrow))
})

test_that("warn that split variables that are not group variables are ignored", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  test_pl_grp <- test_pl |> group_by(Species)

  expect_warning(
    group_split(test_pl_grp, Sepal.Length),
    "is already grouped so variables"
  )
})
