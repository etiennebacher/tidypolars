test_that("basic behavior works", {
  test <- polars0::pl$DataFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))

  expect_is_tidypolars(uncount(test, n))

  expect_equal(
    uncount(test, n),
    pl$DataFrame(x = c("a", "b", "b"), y = c(100, 101, 101))
  )

  expect_equal(
    uncount(test, n, .id = "id"),
    pl$DataFrame(x = c("a", "b", "b"), y = c(100, 101, 101), id = c(1, 1, 2))
  )

  expect_equal(
    uncount(test, n, .remove = FALSE),
    pl$DataFrame(x = c("a", "b", "b"), y = c(100, 101, 101), n = c(1, 2, 2))
  )
})

test_that("works with constant", {
  test <- polars0::pl$DataFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))

  expect_equal(
    uncount(test, 2),
    pl$DataFrame(
      x = c("a", "a", "b", "b"),
      y = c(100, 100, 101, 101),
      n = c(1, 1, 2, 2)
    )
  )
})

test_that("works with expression", {
  test <- polars0::pl$DataFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))

  expect_equal(
    uncount(test, 2 / n),
    pl$DataFrame(x = c("a", "a", "b"), y = c(100, 100, 101), n = c(1, 1, 2))
  )
})
