test_that("basic behavior works", {
  test <- polars::pl$DataFrame(
    a = c(1, NA, NA, NA),
    b = c(1, 2, NA, NA),
    c = c(5, NA, 3, NA)
  )

  expect_equal(
    test |> mutate(d = coalesce(a, b, c)) |> pull(d),
    c(1, 2, 3, NA)
  )

  expect_equal(
    test |> mutate(d = coalesce(a, b, c, default = 10)) |> pull(d),
    c(1, 2, 3, 10)
  )
})

test_that("convert all new column to supertype", {
  test <- polars::pl$DataFrame(
    a = c(1, NA, NA, NA),
    b = c("1", "2", NA, NA),
    c = c(5, NA, 3, NA)
  )

  expect_equal(
    test |> mutate(d = coalesce(a, b, c)) |> pull(d),
    c("1.0", "2", "3.0", NA)
  )
})
