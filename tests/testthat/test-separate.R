test_that("basic behavior works", {
  test <- tibble(x = c(NA, "x.y", "x.z", "y.z"))
  test_pl <- as_polars_df(test)

  expect_is_tidypolars(separate(
    test_pl,
    x,
    into = c("foo", "foo2"),
    sep = "\\."
  ))

  expect_equal(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "\\."),
    separate(test, x, into = c("foo", "foo2"), sep = "\\.")
  )

  expect_equal(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "."),
    suppressWarnings(
      separate(test, x, into = c("foo", "foo2"), sep = ".")
    )
  )
})

test_that("default value for sep works", {
  test <- tibble(x = c(NA, "x y", "x  z", "y   z  u"))
  test_pl <- as_polars_df(test)

  expect_equal(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "\\s+"),
    suppressWarnings(
      separate(test, x, into = c("foo", "foo2"), sep = "\\s+")
    )
  )
})

test_that("tidypolars only supports character separator", {
  test <- pl$DataFrame(x = c(NA, "x y", "x  z", "y   z"))

  expect_snapshot(
    separate(test_pl, x, into = c("foo", "foo2"), sep = 1),
    error = TRUE
  )
})
