test_that("basic behavior works", {
  test_df <- tibble(x = c("a", "b"), y = 100:101, n = c(1L, 2L))
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(uncount(test_pl, n))

  expect_equal(
    uncount(test_pl, n),
    uncount(test_df, n)
  )

  expect_equal(
    uncount(test_pl, n, .id = "id"),
    uncount(test_df, n, .id = "id")
  )

  expect_equal(
    uncount(test_pl, n, .remove = FALSE),
    uncount(test_df, n, .remove = FALSE)
  )
})

test_that("works with constant", {
  test_df <- tibble(x = c("a", "b"), y = 100:101, n = c(1L, 2L))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    uncount(test_pl, 2),
    uncount(test_df, 2)
  )
})

test_that("works with expression", {
  test_df <- tibble(x = c("a", "b"), y = 100:101, n = c(1L, 2L))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    uncount(test_pl, 2 / n),
    uncount(test_df, 2 / n)
  )
})
