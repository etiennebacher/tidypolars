### [GENERATED AUTOMATICALLY] Update test-relocate.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test_df)

  expect_is_tidypolars(relocate(test_pl))
  expect_is_tidypolars(relocate(test_pl, hp, .before = cyl))

  expect_equal_lazy(
    test_pl |> relocate(hp, vs, .before = cyl),
    test_df |> relocate(hp, vs, .before = cyl)
  )

  expect_equal_lazy(
    relocate(test_pl),
    relocate(test_df)
  )
})

test_that("moved to first positions if no .before or .after", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> relocate(hp, vs),
    test_df |> relocate(hp, vs)
  )
})

test_that(".before and .after can be quoted or unquoted", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> relocate(hp, vs, .after = "gear"),
    test_df |> relocate(hp, vs, .after = "gear")
  )
})

test_that("select helpers are also available", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> relocate(matches("[aeiouy]")),
    test_df |> relocate(matches("[aeiouy]"))
  )

  expect_equal_lazy(
    test_pl |> relocate(hp, vs, .after = last_col()),
    test_df |> relocate(hp, vs, .after = last_col())
  )

  expect_equal_lazy(
    test_pl |> relocate(hp, vs, .before = last_col()),
    test_df |> relocate(hp, vs, .before = last_col())
  )
})

test_that("error cases work", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    test_pl |> relocate(mpg, .before = cyl, .after = drat),
    test_df |> relocate(mpg, .before = cyl, .after = drat)
  )
  expect_snapshot_lazy(
    test_pl |> relocate(mpg, .before = cyl, .after = drat),
    error = TRUE
  )

  expect_both_error(
    test_pl |> relocate(mpg, .before = foo),
    test_df |> relocate(mpg, .before = foo)
  )
  expect_snapshot_lazy(
    test_pl |> relocate(mpg, .before = foo),
    error = TRUE
  )

  expect_both_error(
    test_pl |> relocate(mpg, .after = foo),
    test_df |> relocate(mpg, .after = foo)
  )
  expect_snapshot_lazy(
    test_pl |> relocate(mpg, .after = foo),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
