test_that("basic behavior works", {
  tmp <- as_tibble(mtcars)
  tmp[1:3, "mpg"] <- NA
  tmp[4, "hp"] <- NA
  tmp_pl <- as_polars_df(tmp)

  expect_is_tidypolars(drop_na(tmp_pl, drat))

  expect_equal(
    drop_na(tmp_pl, drat),
    drop_na(tmp, drat)
  )

  expect_equal(
    drop_na(tmp_pl, hp),
    drop_na(tmp, hp)
  )

  expect_equal(
    drop_na(tmp_pl, mpg),
    drop_na(tmp, mpg)
  )

  expect_equal(
    drop_na(tmp_pl, mpg, hp),
    drop_na(tmp, mpg, hp)
  )

  expect_equal(
    drop_na(tmp_pl),
    drop_na(tmp)
  )
})

test_that("error if variable doesn't exist", {
  tmp_pl <- polars::as_polars_df(mtcars)
  expect_snapshot(
    drop_na(tmp_pl, foo),
    error = TRUE
  )
})
