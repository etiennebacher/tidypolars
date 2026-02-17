test_that("as_tibble() works", {
  test_pl <- pl$DataFrame(
    x1 = c("a", "a", "b"),
    x2 = 1:3,
    .schema_overrides = list(x2 = polars::pl$Int64)
  )

  expect_equal(
    as_tibble(test_pl),
    tibble(x1 = c("a", "a", "b"), x2 = 1:3)
  )

  expect_equal(
    as_tibble(test_pl, int64 = "character"),
    tibble(x1 = c("a", "a", "b"), x2 = c("1", "2", "3"))
  )
})
