test_that(".tp environment works with base functions", {
  test_df <- tibble(x = 1:3)
  test_pl <- as_polars_df(test_df)
  expect_equal(
    mutate(test_pl, y = .tp$sin(x)),
    mutate(test_df, y = sin(x))
  )
})

test_that(".tp environment works with package functions", {
  test_df <- tibble(x = c("abc12", "def345"))
  test_pl <- as_polars_df(test_df)
  expect_equal(
    mutate(test_pl, y = .tp$str_extract_stringr(x, "\\d+")),
    mutate(test_df, y = stringr::str_extract(x, "\\d+"))
  )
})
