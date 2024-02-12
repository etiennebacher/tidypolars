### [GENERATED AUTOMATICALLY] Update test_rename.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_test <- polars::pl$LazyFrame(mtcars)

expect_is_tidypolars(rename(pl_test, miles_per_gallon = "mpg"))

test1 <- rename(pl_test, miles_per_gallon = "mpg", n_cyl = "cyl") |>
  names()

expect_true("miles_per_gallon" %in% test1)
expect_true("n_cyl" %in% test1)
expect_false("mpg" %in% test1)
expect_false("cyl" %in% test1)

test2 <- rename(pl_test, miles_per_gallon = mpg, n_cyl = "cyl") |>
  names()

expect_true("miles_per_gallon" %in% test2)
expect_true("n_cyl" %in% test2)
expect_false("mpg" %in% test2)
expect_false("cyl" %in% test2)

test3 <- rename_with(pl_test, toupper, c(mpg, cyl)) |>
  names()

expect_true("MPG" %in% test3)
expect_true("CYL" %in% test3)
expect_false("mpg" %in% test3)
expect_false("cyl" %in% test3)

test3bis <- rename_with(pl_test, toupper) |>
  names()

expect_true("DISP" %in% test3bis)
expect_true("DRAT" %in% test3bis)
expect_false("mpg" %in% test3bis)

test4 <- rename_with(pl_test, toupper, contains("p")) |>
  names()

expect_true("MPG" %in% test4)
expect_true("DISP" %in% test4)
expect_true("HP" %in% test4)
expect_false("mpg" %in% test4)
expect_false("disp" %in% test4)

pl_test_2 <- polars::pl$LazyFrame(iris)

test5 <- rename_with(
  pl_test_2,
  \(x) tolower(gsub(".", "_", x, fixed = TRUE))
)

expect_colnames(
  test5,
  c("sepal_length", "sepal_width", "petal_length", "petal_width", "species")
)

test6 <- rename_with(
  pl_test_2,
  function(x) tolower(gsub(".", "_", x, fixed = TRUE))
)

expect_is_tidypolars(test6)

expect_colnames(
  test6,
  c("sepal_length", "sepal_width", "petal_length", "petal_width", "species")
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)