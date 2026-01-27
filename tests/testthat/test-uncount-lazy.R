### [GENERATED AUTOMATICALLY] Update test-uncount.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- tibble(x = c("a", "b"), y = 100:101, n = c(1L, 2L))
  test_pl <- as_polars_lf(test)

  expect_is_tidypolars(uncount(test_pl, n))

  expect_equal_lazy(
    uncount(test_pl, n),
    uncount(test, n)
  )

  expect_equal_lazy(
    uncount(test_pl, n, .id = "id"),
    uncount(test, n, .id = "id")
  )

  expect_equal_lazy(
    uncount(test_pl, n, .remove = FALSE),
    uncount(test, n, .remove = FALSE)
  )
})

test_that("works with constant", {
  test <- tibble(x = c("a", "b"), y = 100:101, n = c(1L, 2L))
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    uncount(test_pl, 2),
    uncount(test, 2)
  )
})

test_that("works with expression", {
  test <- tibble(x = c("a", "b"), y = 100:101, n = c(1L, 2L))
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    uncount(test_pl, 2 / n),
    uncount(test, 2 / n)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
