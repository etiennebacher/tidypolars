test_that("as_tibble() works", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b"),
    x2 = 1:3,
    .schema_overrides = list(x2 = neopolars::pl$Int64)
  )

  expect_equal(
    as_tibble(test),
    dplyr::tibble(x1 = c("a", "a", "b"), x2 = 1:3)
  )

  expect_equal(
    as_tibble(test, int64 = "character"),
    dplyr::tibble(x1 = c("a", "a", "b"), x2 = c("1", "2", "3"))
  )
})
