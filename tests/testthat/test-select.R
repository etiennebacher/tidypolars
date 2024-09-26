test_that("basic behavior works", {
  pl_iris <- polars::pl$DataFrame(iris)

  expect_is_tidypolars(select(pl_iris, c("Sepal.Length", "Sepal.Width")))

  expect_colnames(
    select(pl_iris, c("Sepal.Length", "Sepal.Width")),
    c("Sepal.Length", "Sepal.Width")
  )

  expect_colnames(
    select(pl_iris, Sepal.Length, Sepal.Width),
    c("Sepal.Length", "Sepal.Width")
  )

  expect_colnames(
    select(pl_iris, 1:4),
    c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
  )

  expect_colnames(
    select(pl_iris, -5),
    c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
  )
})

test_that("select helpers work", {
  pl_iris <- polars::pl$DataFrame(iris)
  expect_colnames(
    select(pl_iris, starts_with("Sepal")),
    c("Sepal.Length", "Sepal.Width")
  )
  
  expect_colnames(
    select(pl_iris, ends_with("Length")),
    c("Sepal.Length", "Petal.Length")
  )
  
  expect_colnames(
    select(pl_iris, contains(".")),
    c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
  )
  
  selection <- c("Sepal.Length", "Sepal.Width")
  
  expect_colnames(
    select(pl_iris, all_of(selection)),
    c("Sepal.Length", "Sepal.Width")
  )
  
  expect_colnames(
    select(pl_iris, any_of(selection)),
    c("Sepal.Length", "Sepal.Width")
  )
  
  bad_selection <- c("Sepal.Length", "Sepal.Width", "foo")
  
  expect_error(
    select(pl_iris, all_of(bad_selection)),
    "don't exist"
  )
  
  expect_colnames(
    select(pl_iris, any_of(bad_selection)),
    c("Sepal.Length", "Sepal.Width")
  )
  
  expect_colnames(
    select(pl_iris, where(is.numeric)),
    c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
  )
  
  expect_colnames(
    select(pl_iris, where(is.factor)),
    "Species"
  )
  
  expect_error(
    select(pl_iris, where(~ mean(.x) > 3.5)),
    "can only take `is.*` functions"
  )
  
  expect_colnames(
    select(pl_iris, last_col(3)),
    "Sepal.Width"
  )
  
  expect_colnames(
    select(pl_iris, 1:last_col(3)),
    c("Sepal.Length", "Sepal.Width")
  )
  
  test <- polars::pl$DataFrame(
    x1 = "a", x2 = 1, x3 = "b", y = 2,
    x01 = "a", x02 = 1, x03 = "b"
  )
  
  expect_colnames(
    select(test, num_range("x", 2:3)),
    c("x2", "x3")
  )
  
  expect_colnames(
    select(test, num_range("x", 2:3, width = 2)),
    c("x02", "x03")
  )
})

test_that("renaming in select works", {
  test <- polars::pl$DataFrame(iris)

  expect_equal(
    select(test, foo = Sepal.Length, foo2 = Species),
    select(test, Sepal.Length, Species) |>
      rename(foo = Sepal.Length, foo2 = Species)
  )

  expect_equal(
    select(test, foo = Sepal.Length, everything(), foo2 = Species),
    select(test, Sepal.Length, everything(), Species) |>
      rename(foo = Sepal.Length, foo2 = Species)
  )

  expect_equal(
    select(test, foo = contains("tal")),
    select(test, Petal.Length, Petal.Width) |>
      rename(foo1 = Petal.Length, foo2 = Petal.Width)
  )
})