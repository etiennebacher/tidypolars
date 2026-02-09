### [GENERATED AUTOMATICALLY] Update test-separate.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- tibble(x = c(NA, "x.y", "x.z", "y.z"))
  test_pl <- as_polars_lf(test)

  expect_is_tidypolars(separate(
    test_pl,
    x,
    into = c("foo", "foo2"),
    sep = "\\."
  ))

  expect_equal_lazy(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "\\."),
    separate(test, x, into = c("foo", "foo2"), sep = "\\.")
  )

  expect_equal_lazy(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "."),
    suppressWarnings(
      separate(test, x, into = c("foo", "foo2"), sep = ".")
    )
  )
})

test_that("default value for sep works", {
  test <- tibble(x = c(NA, "x y", "x  z", "y   z  u"))
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "\\s+"),
    suppressWarnings(
      separate(test, x, into = c("foo", "foo2"), sep = "\\s+")
    )
  )
})

test_that("sep must be a valid regex", {
  test <- tibble(x = c(NA, "x y", "x  z", "y   z  u"))
  test_pl <- as_polars_lf(test)

  expect_both_error(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "("),
    separate(test, x, into = c("foo", "foo2"), sep = "(")
  )
  expect_snapshot_lazy(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "("),
    error = TRUE
  )
})

test_that("tidypolars only supports character separator", {
  test <- pl$LazyFrame(x = c(NA, "x y", "x  z", "y   z"))

  expect_snapshot_lazy(
    separate(test, x, into = c("foo", "foo2"), sep = 1),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
