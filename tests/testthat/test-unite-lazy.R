### [GENERATED AUTOMATICALLY] Update test-unite.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_lf(test)

  out <- unite(test_pl, col = "full_date", year, month, day, sep = "-")

  expect_is_tidypolars(out)

  expect_equal_lazy(
    out,
    tidyr::unite(test, col = "full_date", year, month, day, sep = "-")
  )
})

test_that("argument remove works", {
  test <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_lf(test)

  out <- unite(
    test_pl,
    col = "full_date",
    year,
    month,
    day,
    sep = "-",
    remove = FALSE
  )

  expect_equal_lazy(
    out,
    tidyr::unite(
      test,
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
  test <- tibble(
    name = c("John", "Jack", "Thomas"),
    middlename = c("T.", NA, "F."),
    surname = c("Smith", "Thompson", "Jones")
  )
  test_pl <- as_polars_lf(test)

  out <- unite(
    test_pl,
    col = "full_name",
    everything(),
    sep = " ",
    na.rm = TRUE
  )

  expect_equal_lazy(
    pull(out, full_name),
    c("John T. Smith", "Jack  Thompson", "Thomas F. Jones")
  )
})

test_that("name of output column must be provided", {
  test <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_lf(test)

  expect_snapshot_lazy(
    unite(test_pl),
    error = TRUE
  )
})

test_that("no selection selects all columns", {
  test <- tibble(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> unite(col = "foo") |> pull(foo),
    c("2009_10_11_Monday", "2010_11_22_Thursday", "2011_12_28_Wednesday")
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
