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

  # tidypolars-specific (dplyr::coalesce doesn't have `default` argument)
  expect_equal_lazy(
    test_pl |> mutate(d = coalesce(a, b, c, default = 10)) |> pull(d),
    c(1, 2, 3, 10)
  )
})

test_that("convert all new column to supertype", {
  # tidypolars-specific (polars converts to supertype differently than dplyr)
  test <- tibble(
    a = c(1, NA, NA, NA),
    b = c("1", "2", NA, NA),
    c = c(5, NA, 3, NA)
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> mutate(d = coalesce(a, b, c)) |> pull(d),
    c("1.0", "2", "3.0", NA)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
