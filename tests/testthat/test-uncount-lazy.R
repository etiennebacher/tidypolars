### [GENERATED AUTOMATICALLY] Update test-uncount.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- polars::pl$LazyFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))

  expect_is_tidypolars(uncount(test, n))

  expect_equal_lazy(
    uncount(test, n),
    pl$LazyFrame(x = c("a", "b", "b"), y = c(100, 101, 101))
  )

  expect_equal_lazy(
    uncount(test, n, .id = "id"),
    pl$LazyFrame(x = c("a", "b", "b"), y = c(100, 101, 101), id = c(1, 1, 2))
  )

  expect_equal_lazy(
    uncount(test, n, .remove = FALSE),
    pl$LazyFrame(x = c("a", "b", "b"), y = c(100, 101, 101), n = c(1, 2, 2))
  )
})

test_that("works with constant", {
  test <- polars::pl$LazyFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))

  expect_equal_lazy(
    uncount(test, 2),
    pl$LazyFrame(x = c("a", "a", "b", "b"), y = c(100, 100, 101, 101), n = c(1, 1, 2, 2))
  )
})

test_that("works with expression", {
  test <- polars::pl$LazyFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))

  expect_equal_lazy(
    uncount(test, 2 / n),
    pl$LazyFrame(x = c("a", "a", "b"), y = c(100, 100, 101), n = c(1, 1, 2))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)