test_that("basic behavior works", {
  tmp <- mtcars
  tmp[1:3, "mpg"] <- NA
  tmp[4, "hp"] <- NA
  pl_tmp <- as_polars_df(tmp)

  expect_is_tidypolars(drop_na(pl_tmp, drat))

  expect_dim(
    drop_na(pl_tmp, drat),
    c(32, 11)
  )

  expect_dim(
    drop_na(pl_tmp, hp),
    c(31, 11)
  )

  expect_dim(
    drop_na(pl_tmp, mpg),
    c(29, 11)
  )

  expect_dim(
    drop_na(pl_tmp, mpg, hp),
    c(28, 11)
  )

  expect_dim(
    drop_na(pl_tmp),
    c(28, 11)
  )
})

test_that("error if variable doesn't exist", {
  pl_tmp <- neopolars::as_polars_df(mtcars)
  expect_snapshot(
    drop_na(pl_tmp, foo),
    error = TRUE
  )
})
