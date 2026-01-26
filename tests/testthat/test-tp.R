test_that(".tp environment works with base functions", {
  test <- tibble(x = 1:3)
  test_pl <- as_polars_df(test)
  expect_equal(
    mutate(test_pl, y = .tp$sin(x)),
    mutate(test, y = sin(x))
  )
})

test_that(".tp environment works with package functions", {
  test <- tibble(x = c("abc12", "def345"))
  test_pl <- as_polars_df(test)
  expect_equal(
    mutate(test_pl, y = .tp$str_extract_stringr(x, "\\d+")),
    mutate(test, y = stringr::str_extract(x, "\\d+"))
  )
})
