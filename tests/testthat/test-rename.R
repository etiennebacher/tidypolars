test_that("basic behavior works", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_is_tidypolars(rename(test_pl, miles_per_gallon = "mpg"))

  expect_equal(
    rename(test_pl, miles_per_gallon = "mpg", n_cyl = "cyl") |> names(),
    rename(test, miles_per_gallon = "mpg", n_cyl = "cyl") |> names()
  )

  expect_equal(
    rename(test_pl, miles_per_gallon = mpg, n_cyl = "cyl") |> names(),
    rename(test, miles_per_gallon = mpg, n_cyl = "cyl") |> names()
  )
})

test_that("rename_with works with builtin function", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_equal(
    rename_with(test_pl, toupper, c(mpg, cyl)) |> names(),
    rename_with(test, toupper, c(mpg, cyl)) |> names()
  )

  expect_equal(
    rename_with(test_pl, toupper) |> names(),
    rename_with(test, toupper) |> names()
  )

  expect_equal(
    rename_with(test_pl, toupper, contains("p")) |> names(),
    rename_with(test, toupper, contains("p")) |> names()
  )
})

test_that("rename_with works with custom function", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  fn <- \(x) tolower(gsub(".", "_", x, fixed = TRUE))

  expect_equal(
    rename_with(test_pl, fn) |> names(),
    rename_with(test, fn) |> names()
  )

  fn2 <- function(x) tolower(gsub(".", "_", x, fixed = TRUE))

  expect_is_tidypolars(rename_with(test_pl, fn2))

  expect_equal(
    rename_with(test_pl, fn2) |> names(),
    rename_with(test, fn2) |> names()
  )
})
