### [GENERATED AUTOMATICALLY] Update test-funs_conversion.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test_df <- polars::pl$LazyFrame(
    char1 = c("a", "a", "b"),
    char2 = c("1", "2", "3.5"),
    num1 = 1:3,
    num2 = c(0, 0, 1),
    log1 = c(TRUE, FALSE, TRUE)
  )

  expect_equal_lazy(
    mutate(test_df, char1 = as.numeric(char1)) |> pull(char1),
    rep(NA_real_, 3)
  )
  expect_equal_lazy(
    mutate(test_df, char2 = as.numeric(char2)) |> pull(char2),
    c(1, 2, 3.5)
  )
  expect_equal_lazy(
    mutate(test_df, num1 = as.logical(num1)) |> pull(num1),
    c(TRUE, TRUE, TRUE)
  )
  expect_equal_lazy(
    mutate(test_df, num2 = as.logical(num2)) |> pull(num2),
    c(FALSE, FALSE, TRUE)
  )
  expect_equal_lazy(
    mutate(test_df, num1 = as.character(num1)) |> pull(num1),
    c("1", "2", "3")
  )
  expect_equal_lazy(
    mutate(test_df, log1 = as.character(log1)) |> pull(log1),
    c("true", "false", "true")
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
