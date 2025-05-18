test_that("basic behavior works", {
  test <- neopolars::pl$DataFrame(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )

  out <- unite(test, col = "full_date", year, month, day, sep = "-")

  expect_is_tidypolars(out)

  expect_equal(
    pull(out, full_date),
    c("2009-10-11", "2010-11-22", "2011-12-28")
  )

  expect_dim(out, c(3, 2))
})

test_that("argument remove works", {
  test <- neopolars::pl$DataFrame(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  out <- unite(
    test,
    col = "full_date",
    year,
    month,
    day,
    sep = "-",
    remove = FALSE
  )

  expect_dim(out, c(3, 5))
})

test_that("tidy selection works", {
  test <- neopolars::pl$DataFrame(
    name = c("John", "Jack", "Thomas"),
    middlename = c("T.", NA, "F."),
    surname = c("Smith", "Thompson", "Jones")
  )
  out <- unite(test, col = "full_name", everything(), sep = " ", na.rm = TRUE)

  expect_equal(
    pull(out, full_name),
    c("John T. Smith", "Jack  Thompson", "Thomas F. Jones")
  )
})

test_that("name of output column must be provided", {
  test <- neopolars::pl$DataFrame(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  expect_snapshot(
    unite(test),
    error = TRUE
  )
})

test_that("no selection selects all columns", {
  test <- neopolars::pl$DataFrame(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L),
    name_day = c("Monday", "Thursday", "Wednesday")
  )
  expect_equal(
    test |> unite(col = "foo") |> pull(foo),
    c("2009_10_11_Monday", "2010_11_22_Thursday", "2011_12_28_Wednesday")
  )
})
