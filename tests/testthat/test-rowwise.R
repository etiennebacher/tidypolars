test_that("basic behavior with statistical functions works", {
  test <- tibble(x = c(2, 2), y = c(2, 3), z = c(5, NA)) |>
    rowwise()
  test_pl <- as_polars_df(test) |>
    rowwise()

  expect_is_tidypolars(test_pl)

  expect_equal(
    test_pl |>
      mutate(
        mean = mean(c(x, y, z)),
        sum = sum(c(x, y, z)),
        median = median(c(x, y, z)),
        min = min(c(x, y, z)),
        max = max(c(x, y, z)),
        mean2 = mean(c(x, y, z), na.rm = TRUE),
        sum2 = sum(c(x, y, z), na.rm = TRUE),
        median2 = median(c(x, y, z), na.rm = TRUE),
        min2 = min(c(x, y, z), na.rm = TRUE),
        max2 = max(c(x, y, z), na.rm = TRUE)
      ),
    test |>
      mutate(
        mean = mean(c(x, y, z)),
        sum = sum(c(x, y, z)),
        median = median(c(x, y, z)),
        min = min(c(x, y, z)),
        max = max(c(x, y, z)),
        mean2 = mean(c(x, y, z), na.rm = TRUE),
        sum2 = sum(c(x, y, z), na.rm = TRUE),
        median2 = median(c(x, y, z), na.rm = TRUE),
        min2 = min(c(x, y, z), na.rm = TRUE),
        max2 = max(c(x, y, z), na.rm = TRUE)
      ),
    ignore_attr = TRUE
  )
})

test_that("basic behavior with all() and any() works", {
  # Note: the default behavior with only NA is different between R (and therefore
  # dplyr) and polars:
  # - Polars all() returns TRUE if only NA, R returns NA (unless na.rm = TRUE)
  # - Polars any() returns FALSE if only NA, R returns NA (unless na.rm = TRUE)
  # Therefore the tests below compare only non-NA rows and use hardcoded values
  # for the NA-only rows.

  test <- tibble(
    x = c(TRUE, TRUE),
    y = c(TRUE, FALSE),
    z = c(TRUE, NA)
  ) |>
    rowwise()
  test_pl <- as_polars_df(test) |>
    rowwise()

  expect_equal(
    test_pl |> mutate(m = all(c(x, y, z))),
    test |> mutate(m = all(c(x, y, z))),
    ignore_attr = TRUE
  )

  expect_equal(
    test_pl |> mutate(m = all(c(x, y, !z))),
    test |> mutate(m = all(c(x, y, !z))),
    ignore_attr = TRUE
  )

  expect_equal(
    test_pl |> mutate(m = any(c(x, y, z))),
    test |> mutate(m = any(c(x, y, z))),
    ignore_attr = TRUE
  )

  expect_equal(
    test_pl |> mutate(m = any(c(x, y, !z))),
    test |> mutate(m = any(c(x, y, !z))),
    ignore_attr = TRUE
  )
})

test_that("can only use rowwise() on a subset of functions", {
  # tidypolars-specific error (tidyverse handles range() differently in rowwise)
  test <- tibble(
    x = c(TRUE, TRUE, NA),
    y = c(TRUE, FALSE, NA),
    z = c(TRUE, NA, NA)
  )
  test_pl <- as_polars_df(test) |>
    rowwise()
  expect_snapshot(
    test_pl |> mutate(m = range(c(x, y, !z))),
    error = TRUE
  )
})

test_that("rowwise mode is kept after operations", {
  test <- tibble(
    x = c(TRUE, TRUE, NA),
    y = c(TRUE, FALSE, NA),
    z = c(TRUE, NA, NA)
  )
  test_pl <- as_polars_df(test) |>
    rowwise()

  expect_equal(
    (test_pl |> mutate(m = all(c(x, y, z))) |> attributes())$grp_type,
    "rowwise"
  )

  expect_equal(
    (test_pl |> summarize(m = all(c(x, y, z))) |> attributes())$grp_type,
    "rowwise"
  )
})

test_that("can't apply rowwise on grouped data, and vice versa", {
  # tidypolars-specific errors (tidyverse allows these combinations)
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_snapshot(
    test_pl |> group_by(cyl) |> rowwise(),
    error = TRUE
  )
  expect_snapshot(
    test_pl |> rowwise() |> group_by(cyl),
    error = TRUE
  )
})
