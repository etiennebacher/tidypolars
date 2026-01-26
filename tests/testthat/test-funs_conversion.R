test_that("basic behavior works", {
  test <- tibble(
    char1 = c("a", "a", "b"),
    char2 = c("1", "2", "3.5"),
    num1 = 1:3,
    num2 = c(0, 0, 1),
    log1 = c(TRUE, FALSE, TRUE)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    mutate(test_pl, char1 = as.numeric(char1)),
    mutate(test, char1 = as.numeric(char1)) |> suppressWarnings()
  )
  expect_equal(
    mutate(test_pl, char2 = as.numeric(char2)),
    mutate(test, char2 = as.numeric(char2))
  )
  expect_equal(
    mutate(test_pl, num1 = as.logical(num1)),
    mutate(test, num1 = as.logical(num1))
  )
  expect_equal(
    mutate(test_pl, num2 = as.logical(num2)),
    mutate(test, num2 = as.logical(num2))
  )
  expect_equal(
    mutate(test_pl, num1 = as.character(num1)),
    mutate(test, num1 = as.character(num1))
  )
  expect_equal(
    mutate(test_pl, log1 = as.character(log1)),
    mutate(test, log1 = c("true", "false", "true"))
  )
})

test_that("as.Date() works for character columns", {
  test <- tibble(a = "2020-01-01")
  test_pl <- as_polars_df(test)
  expect_equal(
    mutate(test_pl, a = as.Date(a)),
    mutate(test, a = as.Date(a))
  )

  test <- tibble(a = c("2020-01-01", "abc"))
  test_pl <- as_polars_df(test)
  expect_equal(
    mutate(test_pl, a = as.Date(a)),
    mutate(test, a = as.Date(a))
  )
  expect_equal(
    mutate(test_pl, a = as.Date(a, format = "%Y-%m-%d")),
    mutate(test, a = as.Date(a, format = "%Y-%m-%d"))
  )

  expect_snapshot(
    mutate(
      test_pl,
      a = as.Date(a, format = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d"))
    ),
    error = TRUE
  )
  expect_warning(
    expect_equal(
      mutate(
        test_pl,
        a = as.Date(a, tryFormats = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d"))
      ),
      mutate(
        test,
        a = as.Date(a, tryFormats = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d"))
      )
    ),
    'The following argument(s) will be ignored:',
    fixed = TRUE
  )
  expect_warning(
    expect_equal(
      mutate(test_pl, a = as.Date(a, optional = TRUE)),
      mutate(test, a = as.Date(a, optional = TRUE))
    ),
    'The following argument(s) will be ignored:',
    fixed = TRUE
  )

  test_pl <- pl$DataFrame(a = 1)
  expect_error(
    mutate(test_pl, a = as.Date(a)),
    "expected `String`"
  )

  test <- tibble(a = as.Date("2020-01-01"))
  test_pl <- as_polars_df(test)
  expect_equal(
    test_pl |> filter(a >= as.Date("2020-01-01")),
    test |> filter(a >= as.Date("2020-01-01"))
  )
})
