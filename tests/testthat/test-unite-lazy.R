### [GENERATED AUTOMATICALLY] Update test-unite.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test_df <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_lf(test_df)

  out <- unite(test_pl, col = "full_date", year, month, day, sep = "-")

  expect_is_tidypolars(out)

  expect_equal_lazy(
    out,
    unite(test_df, col = "full_date", year, month, day, sep = "-")
  )
})

test_that("argument 'remove' works", {
  test_df <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    unite(
      test_pl,
      col = "full_date",
      year,
      month,
      day,
      sep = "-",
      remove = FALSE
    ),
    unite(
      test_df,
      col = "full_date",
      year,
      month,
      day,
      sep = "-",
      remove = FALSE
    )
  )
})

test_that("argument 'na.rm' works", {
  test_df <- tibble(
    name = c(NA, "Jack", "Thomas"),
    middle = c("T.", NA, "F."),
    surname = c(NA, "Thompson", "Jones")
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    unite(test_pl, col = "out", name, middle, surname, sep = "-"),
    unite(test_df, col = "out", name, middle, surname, sep = "-")
  )
  expect_equal_lazy(
    unite(test_pl, col = "out", name, middle, surname, na.rm = FALSE),
    unite(test_df, col = "out", name, middle, surname, na.rm = FALSE)
  )
  expect_equal_lazy(
    unite(test_pl, col = "out", name, middle, surname, na.rm = TRUE),
    unite(test_df, col = "out", name, middle, surname, na.rm = TRUE)
  )
})

test_that("tidy selection works", {
  test_df <- tibble(
    name = c("John", "Jack", "Thomas"),
    middlename = c("T.", NA, "F."),
    surname = c("Smith", "Thompson", "Jones")
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    unite(test_pl, col = "full_name", everything(), sep = " "),
    unite(test_df, col = "full_name", everything(), sep = " ")
  )
})

test_that("name of output column must be provided", {
  test_df <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    unite(test_pl),
    unite(test_df)
  )
  expect_snapshot_lazy(
    unite(test_pl),
    error = TRUE
  )
})

test_that("no selection selects all columns", {
  test_df <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> unite(col = "foo"),
    test_df |> unite(col = "foo")
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
