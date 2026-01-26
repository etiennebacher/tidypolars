### [GENERATED AUTOMATICALLY] Update test-relocate.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_is_tidypolars(relocate(test_pl))
  expect_is_tidypolars(relocate(test_pl, hp, .before = cyl))

  expect_equal_lazy(
    test_pl |> relocate(hp, vs, .before = cyl) |> names(),
    test |> relocate(hp, vs, .before = cyl) |> names()
  )

  expect_equal_lazy(
    relocate(test_pl),
    test_pl
  )
})

test_that("moved to first positions if no .before or .after", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> relocate(hp, vs) |> names(),
    test |> relocate(hp, vs) |> names()
  )
})

test_that(".before and .after can be quoted or unquoted", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> relocate(hp, vs, .after = "gear") |> names(),
    test |> relocate(hp, vs, .after = "gear") |> names()
  )
})

test_that("select helpers are also available", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> relocate(matches("[aeiouy]")) |> names(),
    test |> relocate(matches("[aeiouy]")) |> names()
  )

  expect_equal_lazy(
    test_pl |> relocate(hp, vs, .after = last_col()) |> names(),
    test |> relocate(hp, vs, .after = last_col()) |> names()
  )

  expect_equal_lazy(
    test_pl |> relocate(hp, vs, .before = last_col()) |> names(),
    test |> relocate(hp, vs, .before = last_col()) |> names()
  )
})

test_that("error cases work", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_both_error(
    test_pl |> relocate(mpg, .before = cyl, .after = drat),
    test |> relocate(mpg, .before = cyl, .after = drat)
  )
  expect_snapshot_lazy(
    test_pl |> relocate(mpg, .before = cyl, .after = drat),
    error = TRUE
  )

  expect_both_error(
    test_pl |> relocate(mpg, .before = foo),
    test |> relocate(mpg, .before = foo)
  )
  expect_snapshot_lazy(
    test_pl |> relocate(mpg, .before = foo),
    error = TRUE
  )

  expect_both_error(
    test_pl |> relocate(mpg, .after = foo),
    test |> relocate(mpg, .after = foo)
  )
  expect_snapshot_lazy(
    test_pl |> relocate(mpg, .after = foo),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
