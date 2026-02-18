test_that("basic behavior works", {
  test_df <- tibble(x = c(NA, "x.y", "x.z", "y.z"))
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(separate(
    test_pl,
    x,
    into = c("foo", "foo2"),
    sep = "\\."
  ))

  expect_equal(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "\\."),
    separate(test_df, x, into = c("foo", "foo2"), sep = "\\.")
  )

  expect_equal(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "."),
    suppressWarnings(
      separate(test_df, x, into = c("foo", "foo2"), sep = ".")
    )
  )
})

test_that("default value for sep works", {
  test_df <- tibble(x = c(NA, "x y", "x  z", "y   z  u"))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "\\s+"),
    suppressWarnings(
      separate(test_df, x, into = c("foo", "foo2"), sep = "\\s+")
    )
  )
})

test_that("sep must be a valid regex", {
  test_df <- tibble(x = c(NA, "x y", "x  z", "y   z  u"))
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "("),
    separate(test_df, x, into = c("foo", "foo2"), sep = "(")
  )
  expect_snapshot(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "("),
    error = TRUE
  )
})

test_that("tidypolars only supports character separator", {
  test_pl <- pl$DataFrame(x = c(NA, "x y", "x  z", "y   z"))

  expect_snapshot(
    separate(test_pl, x, into = c("foo", "foo2"), sep = 1),
    error = TRUE
  )
})
