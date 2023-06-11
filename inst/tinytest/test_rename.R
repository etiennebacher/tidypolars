source("helpers.R")
using("tidypolars")

pl_test <- polars::pl$DataFrame(mtcars)

test1 <- pl_rename(pl_test, miles_per_gallon = "mpg", n_cyl = "cyl") |>
  pl_colnames()

expect_true("miles_per_gallon" %in% test1)
expect_true("n_cyl" %in% test1)
expect_false("mpg" %in% test1)
expect_false("cyl" %in% test1)

test2 <- pl_rename(pl_test, list(miles_per_gallon = "mpg", n_cyl = "cyl")) |>
  pl_colnames()

expect_true("miles_per_gallon" %in% test2)
expect_true("n_cyl" %in% test2)
expect_false("mpg" %in% test2)
expect_false("cyl" %in% test2)

test3 <- pl_rename_with(pl_test, toupper, c(mpg, cyl)) |>
  pl_colnames()

expect_true("MPG" %in% test3)
expect_true("CYL" %in% test3)
expect_false("mpg" %in% test3)
expect_false("cyl" %in% test3)

test4 <- pl_rename_with(pl_test, toupper, contains("p")) |>
  pl_colnames()

expect_true("MPG" %in% test4)
expect_true("DISP" %in% test4)
expect_true("HP" %in% test4)
expect_false("mpg" %in% test4)
expect_false("disp" %in% test4)

pl_test_2 <- polars::pl$DataFrame(iris)

test5 <- pl_rename_with(
  pl_test_2,
  \(x) tolower(gsub(".", "_", x, fixed = TRUE))
)

expect_colnames(
  test5,
  c("sepal_length", "sepal_width", "petal_length", "petal_width", "species")
)

test6 <- pl_rename_with(
  pl_test_2,
  function(x) tolower(gsub(".", "_", x, fixed = TRUE))
)

expect_colnames(
  test6,
  c("sepal_length", "sepal_width", "petal_length", "petal_width", "species")
)
