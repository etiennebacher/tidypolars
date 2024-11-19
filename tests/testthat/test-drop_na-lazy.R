### [GENERATED AUTOMATICALLY] Update test-drop_na.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  tmp <- mtcars
  tmp[1:3, "mpg"] <- NA
  tmp[4, "hp"] <- NA
  pl_tmp <- as_polars_lf(tmp)

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
  pl_tmp <- polars::as_polars_lf(mtcars)
  expect_snapshot_lazy(
    drop_na(pl_tmp, foo),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)