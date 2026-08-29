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

test_that("multiple destination columns use their positions", {
  test_df <- tibble(
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    moved = 6
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> relocate(moved, .before = c(d, b)),
    test_df |> relocate(moved, .before = c(d, b))
  )

  expect_equal_lazy(
    test_pl |> relocate(moved, .after = c(d, b)),
    test_df |> relocate(moved, .after = c(d, b))
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

  expect_equal_lazy(
    test_pl |> relocate(hp, .before = starts_with("c")),
    test_df |> relocate(hp, .before = starts_with("c"))
  )

  expect_equal_lazy(
    test_pl |> relocate(hp, .after = starts_with("c")),
    test_df |> relocate(hp, .after = starts_with("c"))
  )

  expect_equal_lazy(
    test_pl |> relocate(hp, .before = starts_with("not found")),
    test_df |> relocate(hp, .before = starts_with("not found"))
  )

  expect_equal_lazy(
    test_pl |> relocate(hp, .after = starts_with("not found")),
    test_df |> relocate(hp, .after = starts_with("not found"))
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

test_that("relocate() preserves groups", {
  test_df <- tibble(
    g = c("a", "a", "b", "b"),
    h = c(1, 2, 1, 2),
    x = 1:4
  )
  test_pl <- as_polars_lf(test_df) |>
    group_by(g, h, maintain_order = TRUE)
  test_df <- group_by(test_df, g, h)

  expect_equal_lazy(
    relocate(test_pl, x, .before = g),
    relocate(test_df, x, .before = g)
  )
  expect_equal_lazy(
    relocate(test_pl, g, .after = x),
    relocate(test_df, g, .after = x)
  )
  expect_equal_lazy(
    relocate(test_pl, x, .before = g) |> summarize(mean = mean(x)),
    relocate(test_df, x, .before = g) |> summarize(mean = mean(x))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
