test_that("basic behavior works", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  expect_is_tidypolars(select(test_pl, c("Sepal.Length", "Sepal.Width")))

  expect_equal(
    select(test_pl, c("Sepal.Length", "Sepal.Width")) |> names(),
    select(test, c("Sepal.Length", "Sepal.Width")) |> names()
  )

  expect_equal(
    select(test_pl, Sepal.Length, Sepal.Width) |> names(),
    select(test, Sepal.Length, Sepal.Width) |> names()
  )

  expect_equal(
    select(test_pl, 1:4) |> names(),
    select(test, 1:4) |> names()
  )

  expect_equal(
    select(test_pl, -5) |> names(),
    select(test, -5) |> names()
  )
})

test_that("select helpers work", {
  test <- as_tibble(iris)
  test_pl <- as_polars_df(test)

  expect_equal(
    select(test_pl, starts_with("Sepal")) |> names(),
    select(test, starts_with("Sepal")) |> names()
  )

  expect_equal(
    select(test_pl, ends_with("Length")) |> names(),
    select(test, ends_with("Length")) |> names()
  )

  expect_equal(
    select(test_pl, contains(".")) |> names(),
    select(test, contains(".")) |> names()
  )

  selection <- c("Sepal.Length", "Sepal.Width")

  expect_equal(
    select(test_pl, all_of(selection)) |> names(),
    select(test, all_of(selection)) |> names()
  )

  expect_equal(
    select(test_pl, any_of(selection)) |> names(),
    select(test, any_of(selection)) |> names()
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
    select(test_pl, any_of(bad_selection)) |> names(),
    select(test, any_of(bad_selection)) |> names()
  )

  expect_equal(
    select(test_pl, where(is.numeric)) |> names(),
    select(test, where(is.numeric)) |> names()
  )

  expect_equal(
    select(test_pl, where(is.factor)) |> names(),
    select(test, where(is.factor)) |> names()
  )

  # tidypolars-specific (tidypolars doesn't support formula predicates in where())
  expect_snapshot(
    select(test_pl, where(~ mean(.x) > 3.5)),
    error = TRUE
  )

  expect_equal(
    select(test_pl, last_col(3)) |> names(),
    select(test, last_col(3)) |> names()
  )

  expect_equal(
    select(test_pl, 1:last_col(3)) |> names(),
    select(test, 1:last_col(3)) |> names()
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
    select(test2_pl, num_range("x", 2:3)) |> names(),
    select(test2, num_range("x", 2:3)) |> names()
  )

  expect_equal(
    select(test2_pl, num_range("x", 2:3, width = 2)) |> names(),
    select(test2, num_range("x", 2:3, width = 2)) |> names()
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
