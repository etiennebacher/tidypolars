### [GENERATED AUTOMATICALLY] Update test-tp.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that(".tp environment works with base functions", {
  test <- tibble(x = 1:3)
  test_pl <- as_polars_lf(test)
  expect_equal_lazy(
    mutate(test_pl, y = .tp$sin(x)),
    mutate(test, y = sin(x))
  )
})

test_that(".tp environment works with package functions", {
  test <- tibble(x = c("abc12", "def345"))
  test_pl <- as_polars_lf(test)
  expect_equal_lazy(
    mutate(test_pl, y = .tp$str_extract_stringr(x, "\\d+")),
    mutate(test, y = stringr::str_extract(x, "\\d+"))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
