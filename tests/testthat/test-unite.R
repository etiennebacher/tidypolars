test_that("basic behavior works", {
  test_df <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_df(test_df)

  out <- unite(test_pl, col = "full_date", year, month, day, sep = "-")

  expect_is_tidypolars(out)

  expect_equal(
    out,
    unite(test_df, col = "full_date", year, month, day, sep = "-")
  )
})

test_that("argument remove works", {
  test_df <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
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

test_that("tidy selection works", {
  test_df <- tibble(
    name = c("John", "Jack", "Thomas"),
    middlename = c("T.", NA, "F."),
    surname = c("Smith", "Thompson", "Jones")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    unite(
      test_pl,
      col = "full_name",
      everything(),
      sep = " ",
      na.rm = TRUE
    ),
    unite(
      test_df,
      col = "full_name",
      everything(),
      sep = " ",
      na.rm = TRUE
    )
  )
})

test_that("name of output column must be provided", {
  test_df <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    unite(test_pl),
    unite(test_df)
  )
  expect_snapshot(
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
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unite(col = "foo"),
    test_df |> unite(col = "foo")
  )
})
