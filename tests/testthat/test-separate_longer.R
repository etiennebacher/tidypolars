test_that("separate_longer_delim_polars returns custom class", {
  test_pl <- pl$DataFrame(
    id = 1:3,
    x = c("a,b,c", "d,e", "f")
  )
  expect_is_tidypolars(test_pl |> separate_longer_delim_polars(x, delim = ","))
})

test_that("separate_longer_delim_polars basic functionality", {
  test_df <- tibble(
    id = 1:3,
    x = c("a,b,c", "d,e", "f")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_delim_polars(x, delim = ","),
    test_df |> separate_longer_delim(x, delim = ",")
  )
  expect_equal(
    test_pl |> separate_longer_delim_polars(x, delim = "."),
    test_df |> separate_longer_delim(x, delim = ".")
  )
})

test_that("separate_longer_delim_polars multiple delims in text", {
  test_df <- tibble(
    id = 1:3,
    x = c(",a,,b,,c", "d,,,e,", "f,,,")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_delim_polars(x, delim = ","),
    test_df |> separate_longer_delim(x, delim = ",")
  )
})

test_that("separate_longer_delim_polars with empty string as delim", {
  test_df <- tibble(
    id = 1:3,
    x = c("abc", "de", "f"),
    y = c("123", "45", "6")
  )
  test_pl <- as_polars_df(test_df)

  # tidyr returns all NAs with empty delimiter with warning
  expect_equal(
    test_pl |> separate_longer_delim_polars(x, delim = ""),
    suppressWarnings(test_df |> separate_longer_delim(x, delim = ""))
  )

  expect_equal(
    test_pl |> separate_longer_delim_polars(c(x, y), delim = ""),
    suppressWarnings(
      test_df |> separate_longer_delim(c(x, y), delim = "")
    )
  )
})

test_that("separate_longer_delim_polars works with multiple columns", {
  test_df <- tibble(
    id = 1:2,
    x = c("a,b", "c,d"),
    y = c("1,2", "3,4")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_delim_polars(c(x, y), delim = ","),
    test_df |> separate_longer_delim(c(x, y), delim = ",")
  )
})

test_that("separate_longer_delim_polars supports tidyselect", {
  test_df <- tibble(
    id = 1:2,
    x1 = c("a,b", "c"),
    x2 = c("1,2", "3,4"),
    y = c("u", "v")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_delim_polars(c("x1", "x2"), delim = ","),
    test_df |> separate_longer_delim(c("x1", "x2"), delim = ",")
  )

  expect_equal(
    test_pl |>
      separate_longer_delim_polars(tidyselect::starts_with("x"), delim = ","),
    test_df |> separate_longer_delim(tidyselect::starts_with("x"), delim = ",")
  )
})

test_that("separate_longer_delim_polars works with 1 to n and n to 1 broadcasting", {
  test_df <- tibble(
    id = 1:6,
    x = c("a", "", "b", "c,d,e", "f,g,h", "i"),
    y = c("", "0", "1,2,3", "3", "4,5,6", "7")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_delim_polars(c(x, y), delim = ","),
    test_df |> separate_longer_delim(c(x, y), delim = ",")
  )
})

test_that("separate_longer_delim_polars handles NA and empty strings", {
  test_df <- tibble(id = 1:3, x = c("a,b", NA, ""))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_delim_polars(x, delim = ","),
    test_df |> separate_longer_delim(x, delim = ",")
  )
})

test_that("separate_longer_delim_polars broadcasting works with NA and empty strings on multiple columns", {
  test_df <- tibble(
    id = 1:5,
    x = c("a,b", NA, "", "c", ""),
    y = c("1", "2,3", "4,5", NA, "")
  )
  test_pl <- as_polars_df(test_df)

  # tidyr::separate_longer_delim(c(x, y), delim = ","):
  #   id    x    y
  # 1  1    a    1
  # 2  1    b    1
  # 3  2 <NA>    2
  # 4  2 <NA>    3
  # 5  3         4
  # 6  3         5
  # 7  4    c <NA>
  # 8  5

  expect_equal(
    test_pl |> separate_longer_delim_polars(c(x, y), delim = ","),
    test_df |> separate_longer_delim(c(x, y), delim = ",")
  )
})

test_that("separate_longer_position_polars returns custom class", {
  test_pl <- pl$DataFrame(id = 1:3, x = c("abcd", "efgh", "ij"))
  expect_is_tidypolars(test_pl |> separate_longer_position_polars(x, width = 2))
})

test_that("separate_longer_position_polars basic functionality", {
  test_df <- tibble(id = 1:3, x = c("abcd", "efg", "ij"))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_position_polars(x, width = 2),
    test_df |> separate_longer_position(x, width = 2)
  )
})

test_that("separate_longer_position_polars works with width=1", {
  test_df <- tibble(id = 1:3, x = c("abc", "de", "f"))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_position_polars(x, width = 1),
    test_df |> separate_longer_position(x, width = 1)
  )
})

test_that("separate_longer_position_polars handles empty strings", {
  test_df <- tibble(id = 1:2, x = c("abc", ""))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_position_polars(x, width = 2),
    test_df |> separate_longer_position(x, width = 2)
  )
})

test_that("separate_longer_position_polars works with multiple columns", {
  test_df <- tibble(
    id = 1:5,
    x = c("abcd", "efg", "hi", "j", ""),
    y = c("1234", "567", "89", "0", "")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_position_polars(c(x, y), width = 2),
    test_df |> separate_longer_position(c(x, y), width = 2)
  )
})

test_that("separate_longer_position_polars supports tidyselect", {
  test_df <- tibble(
    id = 1:2,
    x1 = c("abcd", "ef"),
    x2 = c("12", "3456"),
    y = c("u", "v")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> separate_longer_position_polars(c("x1", "x2"), width = 2),
    test_df |> separate_longer_position(c("x1", "x2"), width = 2)
  )

  expect_equal(
    test_pl |>
      separate_longer_position_polars(tidyselect::starts_with("x"), width = 2),
    test_df |> separate_longer_position(tidyselect::starts_with("x"), width = 2)
  )
})

test_that("separate_longer_position_polars works with broadcasting on multiple columns", {
  test_df <- tibble(
    id = 1:4,
    x = c("a", "bc", "def", "gh"),
    y = c("12", "345", "67", "")
  )
  test_pl <- as_polars_df(test_df)

  # tidyr::separate_longer_position(c(x, y), width = 2) will get:
  #   id  x  y
  # 1  1  a 12
  # 2  2 bc 34
  # 3  2 bc  5
  # 4  3 de 67
  # 5  3  f 67

  expect_equal(
    test_pl |> separate_longer_position_polars(c(x, y), width = 2),
    test_df |> separate_longer_position(c(x, y), width = 2)
  )

  test2 <- tibble(
    id = 1:4,
    x = c("a", "bc", "def", "gh"),
    y = c("12", "345", "67890", "")
  )
  test2_pl <- as_polars_df(test2)

  # tidyr::separate_longer_position(c(x, y), width = 3) will get:
  #   id   x     y
  # 1  1   a    12
  # 2  2  bc   345
  # 3  3 def   678
  # 4  3 def    90

  expect_equal(
    test2_pl |> separate_longer_position_polars(c(x, y), width = 3),
    test2 |> separate_longer_position(c(x, y), width = 3)
  )
})

test_that("non-string columns are coerced to string (like tidyr)", {
  test_df <- tibble(
    id = 1:3,
    x = c("a,b", "c,d", "e"),
    y = c("abcd", "efg", "hi"),
    z = c(1.4, 2.5, 3.6)
  )
  test_pl <- as_polars_df(test_df)

  # Numeric column is coerced to string, then split by delimiter
  expect_equal(
    test_pl |> separate_longer_delim_polars(z, delim = "."),
    test_df |> separate_longer_delim(z, delim = ".")
  )

  # Multi-column with string and numeric: both processed
  expect_equal(
    test_pl |> separate_longer_delim_polars(c(x, z), delim = "."),
    test_df |> separate_longer_delim(c(x, z), delim = ".")
  )

  # separate_longer_position_polars also coerces to string
  expect_equal(
    test_pl |> separate_longer_position_polars(z, width = 1),
    test_df |> separate_longer_position(z, width = 1)
  )

  expect_equal(
    test_pl |> separate_longer_position_polars(c(y, z), width = 2),
    test_df |> separate_longer_position(c(y, z), width = 2)
  )
})

# Error tests
test_that("errors on non-polars data", {
  test_df <- tibble(id = 1:2, x = c("a,b", "c,d"))

  expect_snapshot(
    test_pl |> separate_longer_delim_polars(x, delim = ","),
    error = TRUE
  )
  expect_snapshot(
    test_pl |> separate_longer_position_polars(x, width = 2),
    error = TRUE
  )
})

test_that("errors on non-existent column", {
  test_df <- tibble(id = 1:2, x = c("a,b", "c,d"))
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> separate_longer_delim_polars(nonexistent, delim = ","),
    test_df |> separate_longer_delim(nonexistent, delim = ",")
  )
  expect_snapshot(
    test_pl |> separate_longer_delim_polars(nonexistent, delim = ","),
    error = TRUE
  )
  expect_both_error(
    test_pl |> separate_longer_position_polars(nonexistent, delim = ","),
    test_df |> separate_longer_position(nonexistent, delim = ",")
  )
  expect_snapshot(
    test_pl |> separate_longer_position_polars(nonexistent, width = 2),
    error = TRUE
  )
})

test_that("errors when cols is missing", {
  test_df <- tibble(id = 1:2, x = c("a,b", "c,d"))
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> separate_longer_delim_polars(delim = ","),
    test_df |> separate_longer_delim(delim = ",")
  )
  expect_snapshot(
    test_pl |> separate_longer_delim_polars(delim = ","),
    error = TRUE
  )
  expect_both_error(
    test_pl |> separate_longer_position_polars(delim = ","),
    test_df |> separate_longer_position(delim = ",")
  )
  expect_snapshot(
    test_pl |> separate_longer_position_polars(width = 2),
    error = TRUE
  )
})

test_that("errors when delim is missing", {
  test_df <- tibble(id = 1:2, x = c("a,b", "c,d"))
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> separate_longer_delim_polars(x),
    test_df |> separate_longer_delim(x)
  )
  expect_snapshot(
    test_pl |> separate_longer_delim_polars(x),
    error = TRUE
  )
})

test_that("errors when width is missing", {
  test_df <- tibble(id = 1:2, x = c("a,b", "c,d"))
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> separate_longer_position_polars(x),
    test_df |> separate_longer_position(x)
  )
  expect_snapshot(
    test_pl |> separate_longer_position_polars(x),
    error = TRUE
  )
})

test_that("errors when width is invalid", {
  test_df <- tibble(id = 1:2, x = c("ab", "cd"))
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> separate_longer_position_polars(x, width = 0),
    test_df |> separate_longer_position(x, width = 0)
  )
  expect_snapshot(
    test_pl |> separate_longer_position_polars(x, width = 0),
    error = TRUE
  )
  expect_both_error(
    test_pl |> separate_longer_position_polars(x, width = 1.5),
    test_df |> separate_longer_position(x, width = 1.5)
  )
  expect_snapshot(
    test_pl |> separate_longer_position_polars(x, width = 1.5),
    error = TRUE
  )
})

test_that("errors when ... is not empty", {
  test_df <- tibble(id = 1:2, x = c("a,b", "c,d"))
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> separate_longer_delim_polars(x, delim = ",", extra = TRUE),
    test_df |> separate_longer_delim(x, delim = ",", extra = TRUE)
  )
  expect_snapshot(
    test_pl |> separate_longer_delim_polars(x, delim = ",", extra = TRUE),
    error = TRUE
  )
  expect_both_error(
    test_pl |> separate_longer_position_polars(x, width = 2, extra = TRUE),
    test_df |> separate_longer_position(x, width = 2, extra = TRUE)
  )
  expect_snapshot(
    test_pl |> separate_longer_position_polars(x, width = 2, extra = TRUE),
    error = TRUE
  )
})

# Error when n to m (n, m >= 2, n != m) - incompatible lengths
test_that("separate_longer_delim_polars errors on incompatible lengths", {
  test_df <- tibble(
    id = 1:2,
    x = c("a,b,c", "d,e"),
    y = c("1,2", "3,4,5,6")
  )
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> separate_longer_delim_polars(c(x, y), delim = ","),
    test_df |> separate_longer_delim(c(x, y), delim = ",")
  )
  expect_snapshot(
    test_pl |> separate_longer_delim_polars(c(x, y), delim = ","),
    error = TRUE
  )
})

# Error when n to m (n, m >= 2, n != m) - incompatible lengths
test_that("separate_longer_position_polars errors on incompatible lengths", {
  test_df <- tibble(
    id = 1:4,
    x = c("a", "bc", "def", "gh"),
    y = c("12", "345", "6789012", "")
  )
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> separate_longer_position_polars(c(x, y), width = 2),
    test_df |> separate_longer_position(c(x, y), width = 2)
  )
  expect_snapshot(
    test_pl |> separate_longer_position_polars(c(x, y), width = 2),
    error = TRUE
  )
})

# tidypolars handles NA correctly
# (tidyr has a bug: tidyverse/tidyr#1625)
test_that("separate_longer_position_polars handles NA values correctly", {
  test_df <- tibble(
    id = 1:3,
    x = c("abcd", NA, "gh"),
    y = c("1234", "5678", NA)
  )
  test_pl <- as_polars_df(test_df)

  result <- test_pl |> separate_longer_position_polars(x, width = 2)
  expected <- pl$DataFrame(
    id = c(1L, 1L, 2L, 3L),
    x = c("ab", "cd", NA, "gh"),
    y = c("1234", "1234", "5678", NA)
  )
  expect_equal(result, expected)

  result <- test_pl |> separate_longer_position_polars(c(x, y), width = 2)
  expected <- pl$DataFrame(
    id = c(1L, 1L, 2L, 2L, 3L),
    x = c("ab", "cd", NA, NA, "gh"),
    y = c("12", "34", "56", "78", NA)
  )
  expect_equal(result, expected)
})

test_that("separate_longer_position_polars handles NA with keep_empty", {
  test_df <- tibble(id = 1:3, x = c("ab", NA, ""))
  test_pl <- as_polars_df(test_df)

  # keep_empty = FALSE (default)
  expect_equal(
    test_pl |> separate_longer_position_polars(x, width = 2),
    pl$DataFrame(
      id = c(1L, 2L),
      x = c("ab", NA)
    )
  )

  # keep_empty = TRUE
  expect_equal(
    test_pl |> separate_longer_position_polars(x, width = 2, keep_empty = TRUE),
    pl$DataFrame(
      id = c(1L, 2L, 3L),
      x = c("ab", NA, NA)
    )
  )
})
