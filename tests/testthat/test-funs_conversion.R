test_that("basic behavior works", {
  test_df <- polars::pl$DataFrame(
    char1 = c("a", "a", "b"),
    char2 = c("1", "2", "3.5"),
    num1 = 1:3,
    num2 = c(0, 0, 1),
    log1 = c(TRUE, FALSE, TRUE)
  )

  expect_equal(
    mutate(test_df, char1 = as.numeric(char1)) |> pull(char1),
    rep(NA_real_, 3)
  )
  expect_equal(
    mutate(test_df, char2 = as.numeric(char2)) |> pull(char2),
    c(1, 2, 3.5)
  )
  expect_equal(
    mutate(test_df, num1 = as.logical(num1)) |> pull(num1),
    c(TRUE, TRUE, TRUE)
  )
  expect_equal(
    mutate(test_df, num2 = as.logical(num2)) |> pull(num2),
    c(FALSE, FALSE, TRUE)
  )
  expect_equal(
    mutate(test_df, num1 = as.character(num1)) |> pull(num1),
    c("1", "2", "3")
  )
  expect_equal(
    mutate(test_df, log1 = as.character(log1)) |> pull(log1),
    c("true", "false", "true")
  )
})

test_that("as.Date() works for character columns", {
  test <- pl$DataFrame(a = "2020-01-01")
  test_df <- as.data.frame(test)
  expect_equal(
    mutate(test, a = as.Date(a)),
    mutate(test_df, a = as.Date(a))
  )

  test <- pl$DataFrame(a = c("2020-01-01", "abc"))
  test_df <- as.data.frame(test)
  expect_equal(
    mutate(test, a = as.Date(a)),
    mutate(test_df, a = as.Date(a))
  )
  expect_equal(
    mutate(test, a = as.Date(a, format = "%Y-%m-%d")),
    mutate(test_df, a = as.Date(a, format = "%Y-%m-%d"))
  )

  expect_snapshot(
    mutate(
      test,
      a = as.Date(a, format = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d"))
    ),
    error = TRUE
  )
  expect_snapshot(
    mutate(
      test,
      a = as.Date(a, tryFormats = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d"))
    )
  )
  expect_snapshot(
    mutate(test, a = as.Date(a, optional = TRUE))
  )

  test <- pl$DataFrame(a = 1)
  expect_error(
    mutate(test, a = as.Date(a)),
    "expected `String`"
  )

  test <- pl$DataFrame(a = as.Date("2020-01-01"))
  test_df <- as.data.frame(test)
  expect_equal(
    test |> filter(a >= as.Date("2020-01-01")),
    test_df |> filter(a >= as.Date("2020-01-01"))
  )
})
