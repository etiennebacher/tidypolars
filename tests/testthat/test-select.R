test_that("basic behavior works", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  expect_is_tidypolars(select(test_pl, c("Sepal.Length", "Sepal.Width")))

  expect_equal(
    select(test_pl, c("Sepal.Length", "Sepal.Width")),
    select(test, c("Sepal.Length", "Sepal.Width"))
  )

  expect_equal(
    select(test_pl, Sepal.Length, Sepal.Width),
    select(test, Sepal.Length, Sepal.Width)
  )

  expect_equal(
    select(test_pl, 1:4),
    select(test, 1:4)
  )

  expect_equal(
    select(test_pl, -5),
    select(test, -5)
  )
})

test_that("select helpers work", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  expect_equal(
    select(test_pl, starts_with("Sepal")),
    select(test, starts_with("Sepal"))
  )

  expect_equal(
    select(test_pl, ends_with("Length")),
    select(test, ends_with("Length"))
  )

  expect_equal(
    select(test_pl, contains(".")),
    select(test, contains("."))
  )

  selection <- c("Sepal.Length", "Sepal.Width")

  expect_equal(
    select(test_pl, all_of(selection)),
    select(test, all_of(selection))
  )

  expect_equal(
    select(test_pl, any_of(selection)),
    select(test, any_of(selection))
  )

  bad_selection <- c("Sepal.Length", "Sepal.Width", "foo")

  expect_both_error(
    select(test_pl, all_of(bad_selection)),
    select(test, all_of(bad_selection))
  )
  expect_snapshot(
    select(test_pl, all_of(bad_selection)),
    error = TRUE
  )

  expect_equal(
    select(test_pl, any_of(bad_selection)),
    select(test, any_of(bad_selection))
  )

  expect_equal(
    select(test_pl, where(is.numeric)),
    select(test, where(is.numeric))
  )

  expect_equal(
    select(test_pl, where(is.factor)),
    select(test, where(is.factor))
  )

  # tidypolars-specific (tidypolars doesn't support formula predicates in where())
  expect_snapshot(
    select(test_pl, where(~ mean(.x) > 3.5)),
    error = TRUE
  )

  expect_equal(
    select(test_pl, last_col(3)),
    select(test, last_col(3))
  )

  expect_equal(
    select(test_pl, 1:last_col(3)),
    select(test, 1:last_col(3))
  )

  test2 <- tibble(
    x1 = "a",
    x2 = 1,
    x3 = "b",
    y = 2,
    x01 = "a",
    x02 = 1,
    x03 = "b"
  )
  test2_pl <- as_polars_df(test2)

  expect_equal(
    select(test2_pl, num_range("x", 2:3)),
    select(test2, num_range("x", 2:3))
  )

  expect_equal(
    select(test2_pl, num_range("x", 2:3, width = 2)),
    select(test2, num_range("x", 2:3, width = 2))
  )
})

test_that("renaming in select works", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  expect_equal(
    select(test_pl, foo = Sepal.Length, foo2 = Species),
    select(test, foo = Sepal.Length, foo2 = Species)
  )

  expect_equal(
    select(test_pl, foo = Sepal.Length, everything(), foo2 = Species),
    select(test, foo = Sepal.Length, everything(), foo2 = Species)
  )

  expect_equal(
    select(test_pl, foo = contains("tal")),
    select(test, foo = contains("tal"))
  )
})
