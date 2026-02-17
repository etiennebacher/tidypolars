test_that("basic behavior works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(rename(test_pl, miles_per_gallon = "mpg"))

  expect_equal(
    rename(test_pl, miles_per_gallon = "mpg", n_cyl = "cyl"),
    rename(test_df, miles_per_gallon = "mpg", n_cyl = "cyl")
  )

  expect_equal(
    rename(test_pl, miles_per_gallon = mpg, n_cyl = "cyl"),
    rename(test_df, miles_per_gallon = mpg, n_cyl = "cyl")
  )
})

test_that("rename_with works with builtin function", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    rename_with(test_pl, toupper, c(mpg, cyl)),
    rename_with(test_df, toupper, c(mpg, cyl))
  )

  expect_equal(
    rename_with(test_pl, toupper),
    rename_with(test_df, toupper)
  )

  expect_equal(
    rename_with(test_pl, toupper, contains("p")),
    rename_with(test_df, toupper, contains("p"))
  )
})

test_that("rename_with works with custom function", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  fn <- \(x) tolower(gsub(".", "_", x, fixed = TRUE))

  expect_equal(
    rename_with(test_pl, fn),
    rename_with(test_df, fn)
  )

  fn2 <- function(x) tolower(gsub(".", "_", x, fixed = TRUE))

  expect_is_tidypolars(rename_with(test_pl, fn2))

  expect_equal(
    rename_with(test_pl, fn2),
    rename_with(test_df, fn2)
  )
})
