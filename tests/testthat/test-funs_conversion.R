test_that("basic behavior works", {
  test_df <- tibble(
    char1 = c("a", "a", "b"),
    char2 = c("1", "2", "3.5"),
    num1 = 1:3,
    num2 = c(0, 0, 1),
    log1 = c(TRUE, FALSE, TRUE)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    mutate(test_pl, char1 = as.numeric(char1)),
    mutate(test_df, char1 = as.numeric(char1)) |> suppressWarnings()
  )
  expect_equal(
    mutate(test_pl, char2 = as.numeric(char2)),
    mutate(test_df, char2 = as.numeric(char2))
  )
  expect_equal(
    mutate(test_pl, num1 = as.logical(num1)),
    mutate(test_df, num1 = as.logical(num1))
  )
  expect_equal(
    mutate(test_pl, num2 = as.logical(num2)),
    mutate(test_df, num2 = as.logical(num2))
  )
  expect_equal(
    mutate(test_pl, num1 = as.character(num1)),
    mutate(test_df, num1 = as.character(num1))
  )
  expect_equal(
    mutate(test_pl, log1 = as.character(log1)),
    mutate(test_df, log1 = c("true", "false", "true"))
  )
})

test_that("as.Date() works for character columns", {
  test_df <- tibble(a = "2020-01-01")
  test_pl <- as_polars_df(test_df)
  expect_equal(
    mutate(test_pl, a = as.Date(a)),
    mutate(test_df, a = as.Date(a))
  )

  test_df <- tibble(a = c("2020-01-01", "abc"))
  test_pl <- as_polars_df(test_df)
  expect_equal(
    mutate(test_pl, a = as.Date(a)),
    mutate(test_df, a = as.Date(a))
  )
  expect_equal(
    mutate(test_pl, a = as.Date(a, format = "%Y-%m-%d")),
    mutate(test_df, a = as.Date(a, format = "%Y-%m-%d"))
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
        test_df,
        a = as.Date(a, tryFormats = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d"))
      )
    ),
    'The following argument(s) will be ignored:',
    fixed = TRUE
  )
  expect_warning(
    expect_equal(
      mutate(test_pl, a = as.Date(a, optional = TRUE)),
      mutate(test_df, a = as.Date(a, optional = TRUE))
    ),
    'The following argument(s) will be ignored:',
    fixed = TRUE
  )

  test_pl <- pl$DataFrame(a = 1)
  expect_error(
    mutate(test_pl, a = as.Date(a)),
    "expected `String`"
  )

  test_df <- tibble(a = as.Date("2020-01-01"))
  test_pl <- as_polars_df(test_df)
  expect_equal(
    test_pl |> filter(a >= as.Date("2020-01-01")),
    test_df |> filter(a >= as.Date("2020-01-01"))
  )
})

test_that("conversion helpers work with literal first argument", {
  test_df <- tibble(x = 1:2)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> mutate(d = as.Date("2020-01-01")),
    test_df |> mutate(d = as.Date("2020-01-01"))
  )

  expect_equal(
    test_pl |> mutate(num = as.numeric("1")),
    test_df |> mutate(num = as.numeric("1"))
  )

  expect_equal(
    test_pl |> mutate(chr = as.character(1L)),
    test_df |> mutate(chr = as.character(1L))
  )

  expect_equal(
    test_pl |> mutate(lgl = as.logical(1)),
    test_df |> mutate(lgl = as.logical(1))
  )
})
