### [GENERATED AUTOMATICALLY] Update test-coalesce.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- tibble(
    a = c(1, NA, NA, NA),
    b = c(1, 2, NA, NA),
    c = c(5, NA, 3, NA)
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> mutate(d = coalesce(a, b, c)),
    test |> mutate(d = coalesce(a, b, c))
  )
})

test_that("convert all new column to supertype", {
  test <- tibble(
    a = c(1, NA, NA, NA),
    b = c("1", "2", NA, NA),
    c = c(5, NA, 3, NA)
  )
  test_pl <- as_polars_lf(test)

  # TODO? dplyr errors because of coercion
  expect_equal_lazy(
    test_pl |> mutate(d = coalesce(a, b, c)),
    pl$LazyFrame(
      a = c(1, NA, NA, NA),
      b = c("1", "2", NA, NA),
      c = c(5, NA, 3, NA),
      d = c("1.0", "2", "3.0", NA),
    )
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
