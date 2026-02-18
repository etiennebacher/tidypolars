### [GENERATED AUTOMATICALLY] Update test-tp.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that(".tp environment works with base functions", {
  test_df <- tibble(x = 1:3)
  test_pl <- as_polars_lf(test_df)
  expect_equal_lazy(
    mutate(test_pl, y = .tp$sin(x)),
    mutate(test_df, y = sin(x))
  )
})

test_that(".tp environment works with package functions", {
  test_df <- tibble(x = c("abc12", "def345"))
  test_pl <- as_polars_lf(test_df)
  expect_equal_lazy(
    mutate(test_pl, y = .tp$str_extract_stringr(x, "\\d+")),
    mutate(test_df, y = stringr::str_extract(x, "\\d+"))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
