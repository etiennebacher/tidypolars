### [GENERATED AUTOMATICALLY] Update test-rename.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  pl_test <- polars::pl$LazyFrame(mtcars)

  expect_is_tidypolars(rename(pl_test, miles_per_gallon = "mpg"))

  test <- rename(pl_test, miles_per_gallon = "mpg", n_cyl = "cyl") |>
    names()

  expect_true("miles_per_gallon" %in% test)
  expect_true("n_cyl" %in% test)
  expect_false("mpg" %in% test)
  expect_false("cyl" %in% test)

  test2 <- rename(pl_test, miles_per_gallon = mpg, n_cyl = "cyl") |>
    names()

  expect_true("miles_per_gallon" %in% test2)
  expect_true("n_cyl" %in% test2)
  expect_false("mpg" %in% test2)
  expect_false("cyl" %in% test2)
})

test_that("rename_with works with builtin function", {
  pl_test <- polars::pl$LazyFrame(mtcars)
  test <- rename_with(pl_test, toupper, c(mpg, cyl)) |>
    names()
  
  expect_true("MPG" %in% test)
  expect_true("CYL" %in% test)
  expect_false("mpg" %in% test)
  expect_false("cyl" %in% test)
  
  testbis <- rename_with(pl_test, toupper) |>
    names()
  
  expect_true("DISP" %in% testbis)
  expect_true("DRAT" %in% testbis)
  expect_false("mpg" %in% testbis)
  
  test4 <- rename_with(pl_test, toupper, contains("p")) |>
    names()
  
  expect_true("MPG" %in% test4)
  expect_true("DISP" %in% test4)
  expect_true("HP" %in% test4)
  expect_false("mpg" %in% test4)
  expect_false("disp" %in% test4)
})

test_that("rename_with works with custom function", {
  pl_test <- polars::pl$LazyFrame(iris)

  test <- rename_with(
    pl_test,
    \(x) tolower(gsub(".", "_", x, fixed = TRUE))
  )

  expect_colnames(
    test,
    c("sepal_length", "sepal_width", "petal_length", "petal_width", "species")
  )

  test2 <- rename_with(
    pl_test,
    function(x) tolower(gsub(".", "_", x, fixed = TRUE))
  )

  expect_is_tidypolars(test2)

  expect_colnames(
    test2,
    c("sepal_length", "sepal_width", "petal_length", "petal_width", "species")
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)