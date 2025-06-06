test_that("basic behavior with statistical functions works", {
  test_df <- data.frame(x = c(2, 2), y = c(2, 3), z = c(5, NA)) |>
    rowwise()
  test <- as_polars_df(test_df) |>
    rowwise()

  expect_is_tidypolars(test)

  expect_equal(
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
    test_df |>
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

  test <- pl$DataFrame(
    x = c(TRUE, TRUE, NA),
    y = c(TRUE, FALSE, NA),
    z = c(TRUE, NA, NA)
  ) |>
    rowwise()

  expect_equal(
    test |>
      mutate(m = all(c(x, y, z))) |>
      pull(m),
    c(TRUE, FALSE, TRUE)
  )

  expect_equal(
    test |>
      mutate(m = all(c(x, y, !z))) |>
      pull(m),
    c(FALSE, FALSE, TRUE)
  )

  expect_equal(
    test |>
      mutate(m = any(c(x, y, z))) |>
      pull(m),
    c(TRUE, TRUE, FALSE)
  )

  expect_equal(
    test |>
      mutate(m = any(c(x, y, !z))) |>
      pull(m),
    c(TRUE, TRUE, FALSE)
  )
})

test_that("can only use rowwise() on a subset of functions", {
  test <- as_polars_df(
    x = c(TRUE, TRUE, NA),
    y = c(TRUE, FALSE, NA),
    z = c(TRUE, NA, NA)
  ) |>
    rowwise()
  expect_snapshot(
    test |> mutate(m = range(c(x, y, !z))),
    error = TRUE
  )
})

test_that("rowwise mode is kept after operations", {
  test <- pl$DataFrame(
    x = c(TRUE, TRUE, NA),
    y = c(TRUE, FALSE, NA),
    z = c(TRUE, NA, NA)
  ) |>
    rowwise()

  expect_equal(
    (test |>
      mutate(m = all(c(x, y, z))) |>
      attributes())$grp_type,
    "rowwise"
  )

  expect_equal(
    (test |>
      summarize(m = all(c(x, y, z))) |>
      attributes())$grp_type,
    "rowwise"
  )
})

test_that("can't apply rowwise on grouped data, and vice versa", {
  expect_snapshot(
    as_polars_df(mtcars) |>
      group_by(cyl) |>
      rowwise(),
    error = TRUE
  )
  expect_snapshot(
    as_polars_df(mtcars) |>
      rowwise() |>
      group_by(cyl),
    error = TRUE
  )
})
