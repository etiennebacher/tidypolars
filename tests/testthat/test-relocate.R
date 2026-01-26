test_that("basic behavior works", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_is_tidypolars(relocate(test_pl))
  expect_is_tidypolars(relocate(test_pl, hp, .before = cyl))

  expect_equal(
    test_pl |> relocate(hp, vs, .before = cyl),
    test |> relocate(hp, vs, .before = cyl)
  )

  expect_equal(
    relocate(test_pl),
    relocate(test)
  )
})

test_that("moved to first positions if no .before or .after", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> relocate(hp, vs),
    test |> relocate(hp, vs)
  )
})

test_that(".before and .after can be quoted or unquoted", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> relocate(hp, vs, .after = "gear"),
    test |> relocate(hp, vs, .after = "gear")
  )
})

test_that("select helpers are also available", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> relocate(matches("[aeiouy]")),
    test |> relocate(matches("[aeiouy]"))
  )

  expect_equal(
    test_pl |> relocate(hp, vs, .after = last_col()),
    test |> relocate(hp, vs, .after = last_col())
  )

  expect_equal(
    test_pl |> relocate(hp, vs, .before = last_col()),
    test |> relocate(hp, vs, .before = last_col())
  )
})

test_that("error cases work", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_both_error(
    test_pl |> relocate(mpg, .before = cyl, .after = drat),
    test |> relocate(mpg, .before = cyl, .after = drat)
  )
  expect_snapshot(
    test_pl |> relocate(mpg, .before = cyl, .after = drat),
    error = TRUE
  )

  expect_both_error(
    test_pl |> relocate(mpg, .before = foo),
    test |> relocate(mpg, .before = foo)
  )
  expect_snapshot(
    test_pl |> relocate(mpg, .before = foo),
    error = TRUE
  )

  expect_both_error(
    test_pl |> relocate(mpg, .after = foo),
    test |> relocate(mpg, .after = foo)
  )
  expect_snapshot(
    test_pl |> relocate(mpg, .after = foo),
    error = TRUE
  )
})
