library(arrow)
library(dplyr)
library(quickcheck)
library(stringr)
library(testthat)

expect_equal_or_both_error <- function(object, other) {
  arrow_error <- FALSE
  arrow_res <- tryCatch(
    object,
    error = function(e) arrow_error <<- TRUE
  )

  other_error <- FALSE
  other_res <- suppressWarnings(
    tryCatch(
      other,
      error = function(e) other_error <<- TRUE
    )
  )

  if (isTRUE(arrow_error)) {
    testthat::expect(
      isTRUE(other_error),
      "arrow errored but tidyverse didn't."
    )
  } else {
    testthat::expect_equal(arrow_res, other_res)
  }

  invisible(NULL)
}

test_that("str_sub() works", {
  for_all(
    tests = 200,
    string = character_(any_na = TRUE),
    start = numeric_(any_na = TRUE),
    end = numeric_(any_na = TRUE),
    property = function(string, start, end) {
      test_df <- data.frame(x1 = string)

      expect_equal_or_both_error(
        mutate(test, foo = str_sub(x1, start, end)) |>
          pull(foo),
        mutate(test_df, foo = str_sub(x1, start, end)) |>
          pull(foo)
      )
    }
  )
})
