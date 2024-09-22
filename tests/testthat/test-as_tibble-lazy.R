### [GENERATED AUTOMATICALLY] Update test-as_tibble.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("as_tibble() works", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b"),
    x2 = 1:3,
    schema = list(x2 = polars::pl$Int64)
  )

  expect_equal_lazy(
    as_tibble(test),
    dplyr::tibble(x1 = c("a", "a", "b"), x2 = 1:3)
  )

  expect_equal_lazy(
    as_tibble(test, int64_conversion = "string"),
    dplyr::tibble(x1 = c("a", "a", "b"), x2 = c("1", "2", "3"))
  )
})


Sys.setenv('TIDYPOLARS_TEST' = FALSE)