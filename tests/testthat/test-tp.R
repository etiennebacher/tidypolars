test_that(".tp environment works with base functions", {
  dat <- pl$DataFrame(x = 1:3)
  dat_df <- as.data.frame(dat)
  expect_equal(
    mutate(dat, y = .tp$sin(x)),
    mutate(dat_df, y = sin(x))
  )
})

test_that(".tp environment works with package functions", {
  dat <- pl$DataFrame(x = c("abc12", "def345"))
  dat_df <- as.data.frame(dat)
  expect_equal(
    mutate(dat, y = .tp$str_extract_stringr(x, "\\d+")),
    mutate(dat_df, y = stringr::str_extract(x, "\\d+"))
  )
})
