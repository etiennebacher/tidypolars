### [GENERATED AUTOMATICALLY] Update test-pull.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("multiplication works", {
  test <- polars::pl$LazyFrame(mtcars)

  expect_equal_lazy(
    pull(test, mpg),
    mtcars$mpg
  )

  expect_equal_lazy(
    pull(test, "mpg"),
    mtcars$mpg
  )

  expect_equal_lazy(
    pull(test, 1),
    mtcars$mpg
  )
})

test_that("error cases work", {
  test <- polars::pl$LazyFrame(mtcars)
  expect_error_lazy(
    pull(test, dplyr::all_of(c("mpg", "drat"))),
    "can only extract one column"
  )

  expect_error_lazy(
    pull(test, mpg, drat, hp)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)