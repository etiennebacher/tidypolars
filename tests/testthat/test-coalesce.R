test_that("basic behavior works", {
  test_df <- tibble(
    a = c(1, NA, NA, NA),
    b = c(1, 2, NA, NA),
    c = c(5, NA, 3, NA)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> mutate(d = coalesce(a, b, c)),
    test_df |> mutate(d = coalesce(a, b, c))
  )
})

test_that("convert all new column to supertype", {
  test_df <- tibble(
    a = c(1, NA, NA, NA),
    b = c("1", "2", NA, NA),
    c = c(5, NA, 3, NA)
  )
  test_pl <- as_polars_df(test_df)

  # TODO? dplyr errors because of coercion
  expect_equal(
    test_pl |> mutate(d = coalesce(a, b, c)),
    pl$DataFrame(
      a = c(1, NA, NA, NA),
      b = c("1", "2", NA, NA),
      c = c(5, NA, 3, NA),
      d = c("1.0", "2", "3.0", NA),
    )
  )
})
