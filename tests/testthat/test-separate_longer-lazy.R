### [GENERATED AUTOMATICALLY] Update test-separate_longer.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("separate_longer_delim_polars returns custom class", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c("a,b,c", "d,e", "f")
  )
  expect_is_tidypolars(df |> separate_longer_delim_polars(x, delim = ","))
})

test_that("separate_longer_delim_polars basic functionality", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c("a,b,c", "d,e", "f")
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(x, delim = ","),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(x, delim = ",") |>
      as.data.frame()
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(x, delim = "."),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(x, delim = ".") |>
      as.data.frame()
  )
})

test_that("separate_longer_delim_polars multiple delims in text", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c(",a,,b,,c", "d,,,e,", "f,,,")
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(x, delim = ","),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(x, delim = ",") |>
      as.data.frame()
  )
})

# This is different from tidyr behavior
# In tidyr, empty string as delim will return all NAs, which I think is unintuitive.
test_that("separate_longer_delim_polars with empty string as delim", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c("abc", "de", "f")
  )

  target_df <- pl$LazyFrame(
    id = c(1L, 1L, 1L, 2L, 2L, 3L),
    x = c("a", "b", "c", "d", "e", "f")
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(x, delim = ""),
    target_df
  )
})

test_that("separate_longer_delim_polars works with multiple columns", {
  df <- pl$LazyFrame(
    id = 1:2,
    x = c("a,b", "c,d"),
    y = c("1,2", "3,4")
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(c(x, y), delim = ","),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(c(x, y), delim = ",") |>
      as.data.frame()
  )
})

test_that("separate_longer_delim_polars supports tidyselect", {
  df <- pl$LazyFrame(
    id = 1:2,
    x1 = c("a,b", "c"),
    x2 = c("1,2", "3,4"),
    y = c("u", "v")
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(c("x1", "x2"), delim = ","),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(c("x1", "x2"), delim = ",") |>
      as.data.frame()
  )

  expect_equal_lazy(
    df |>
      separate_longer_delim_polars(tidyselect::starts_with("x"), delim = ","),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(tidyselect::starts_with("x"), delim = ",") |>
      as.data.frame()
  )
})

test_that("separate_longer_delim_polars works with 1 to n and n to 1 broadcasting", {
  df <- pl$LazyFrame(
    id = 1:6,
    x = c("a", "", "b", "c,d,e", "f,g,h", "i"),
    y = c("", "0", "1,2,3", "3", "4,5,6", "7")
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(c(x, y), delim = ","),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(c(x, y), delim = ",") |>
      as.data.frame()
  )
})

test_that("separate_longer_delim_polars handles NA and empty strings", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c("a,b", NA, "")
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(x, delim = ","),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(x, delim = ",") |>
      as.data.frame()
  )
})

test_that("separate_longer_delim_polars broadcasting works with NA and empty strings on multiple columns", {
  df <- pl$LazyFrame(
    id = 1:5,
    x = c("a,b", NA, "", "c", ""),
    y = c("1", "2,3", "4,5", NA, "")
  )

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

  expect_equal_lazy(
    df |> separate_longer_delim_polars(c(x, y), delim = ","),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(c(x, y), delim = ",") |>
      as.data.frame()
  )
})

test_that("separate_longer_position_polars returns custom class", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c("abcd", "efgh", "ij")
  )
  expect_is_tidypolars(df |> separate_longer_position_polars(x, width = 2))
})

test_that("separate_longer_position_polars basic functionality", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c("abcd", "efg", "ij")
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(x, width = 2),
    as.data.frame(df) |>
      tidyr::separate_longer_position(x, width = 2) |>
      as.data.frame()
  )
})

test_that("separate_longer_position_polars works with width=1", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c("abc", "de", "f")
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(x, width = 1),
    as.data.frame(df) |>
      tidyr::separate_longer_position(x, width = 1) |>
      as.data.frame()
  )
})

test_that("separate_longer_position_polars handles empty strings", {
  df <- pl$LazyFrame(
    id = 1:2,
    x = c("abc", "")
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(x, width = 2),
    as.data.frame(df) |>
      tidyr::separate_longer_position(x, width = 2) |>
      as.data.frame()
  )
})

test_that("separate_longer_position_polars handles NA values", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c("abcd", NA, "ef")
  )

  # tidyr::separate_longer_position errors on NA values,
  # but Polars handles it by keeping NA as is.
  # I think keeping NA is the correct behavior, the same as delim version.
  # Maybe this is a bug in tidyr, because tidyr::separate_longer_delim keeps NA,
  # but tidyr::separate_longer_position don't.
  result <- df |>
    separate_longer_position_polars(x, width = 2) |>
    as.data.frame()

  expect_equal_lazy(result$x, c("ab", "cd", NA, "ef"))
})


test_that("separate_longer_position_polars works with multiple columns", {
  df <- pl$LazyFrame(
    id = 1:5,
    x = c("abcd", "efg", "hi", "j", ""),
    y = c("1234", "567", "89", "0", "")
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(c(x, y), width = 2),
    as.data.frame(df) |>
      tidyr::separate_longer_position(c(x, y), width = 2) |>
      as.data.frame()
  )
})

test_that("separate_longer_position_polars supports tidyselect", {
  df <- pl$LazyFrame(
    id = 1:2,
    x1 = c("abcd", "ef"),
    x2 = c("12", "3456"),
    y = c("u", "v")
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(c("x1", "x2"), width = 2),
    as.data.frame(df) |>
      tidyr::separate_longer_position(c("x1", "x2"), width = 2) |>
      as.data.frame()
  )

  expect_equal_lazy(
    df |>
      separate_longer_position_polars(tidyselect::starts_with("x"), width = 2),
    as.data.frame(df) |>
      tidyr::separate_longer_position(
        tidyselect::starts_with("x"),
        width = 2
      ) |>
      as.data.frame()
  )
})

test_that("separate_longer_position_polars works with broadcasting on multiple columns", {
  df <- pl$LazyFrame(
    id = 1:4,
    x = c("a", "bc", "def", "gh"),
    y = c("12", "345", "67", "")
  )

  # tidyr::separate_longer_position(c(x, y), width = 2) will get:
  #   id  x  y
  # 1  1  a 12
  # 2  2 bc 34
  # 3  2 bc  5
  # 4  3 de 67
  # 5  3  f 67

  expect_equal_lazy(
    df |> separate_longer_position_polars(c(x, y), width = 2),
    as.data.frame(df) |>
      tidyr::separate_longer_position(c(x, y), width = 2) |>
      as.data.frame()
  )

  df_2 <- pl$LazyFrame(
    id = 1:4,
    x = c("a", "bc", "def", "gh"),
    y = c("12", "345", "67890", "")
  )

  # tidyr::separate_longer_position(c(x, y), width = 3) will get:
  #   id   x     y
  # 1  1   a    12
  # 2  2  bc   345
  # 3  3 def   678
  # 4  3 def    90

  expect_equal_lazy(
    df_2 |> separate_longer_position_polars(c(x, y), width = 3),
    as.data.frame(df_2) |>
      tidyr::separate_longer_position(c(x, y), width = 3) |>
      as.data.frame()
  )
})

test_that("separate_longer_position_polars broadcasting works with NA and empty strings on multiple columns", {
  df <- pl$LazyFrame(
    id = 1:4,
    x = c("abcd", NA, "ef", "gh"),
    y = c("12", "34", "", NA)
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(c(x, y), width = 2),
    pl$LazyFrame(
      id = c(1L, 1L, 2L, 4L),
      x = c("ab", "cd", NA, "gh"),
      y = c("12", "12", "34", NA)
    )
  )

  expect_equal_lazy(
    df |>
      separate_longer_position_polars(c(x, y), width = 2, keep_empty = TRUE),
    pl$LazyFrame(
      id = c(1L, 1L, 2L, 3L, 4L),
      x = c("ab", "cd", NA, "ef", "gh"),
      y = c("12", "12", "34", "", NA)
    )
  )
})

test_that("non-string columns are coerced to string (like tidyr)", {
  df <- pl$LazyFrame(
    id = 1:3,
    x = c("a,b", "c,d", "e"),
    y = c("abcd", "efg", "hi"),
    z = c(1.4, 2.5, 3.6)
  )

  # Numeric column is coerced to string, then split by delimiter
  expect_equal_lazy(
    df |> separate_longer_delim_polars(z, delim = "."),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(z, delim = ".") |>
      as.data.frame()
  )

  # Multi-column with string and numeric: both processed
  expect_equal_lazy(
    df |> separate_longer_delim_polars(c(x, z), delim = "."),
    as.data.frame(df) |>
      tidyr::separate_longer_delim(c(x, z), delim = ".") |>
      as.data.frame()
  )

  # separate_longer_position_polars also coerces to string
  expect_equal_lazy(
    df |> separate_longer_position_polars(z, width = 1),
    as.data.frame(df) |>
      tidyr::separate_longer_position(z, width = 1) |>
      as.data.frame()
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(c(y, z), width = 2),
    as.data.frame(df) |>
      tidyr::separate_longer_position(c(y, z), width = 2) |>
      as.data.frame()
  )
})

# Error tests
test_that("errors on non-polars data", {
  df <- data.frame(id = 1:2, x = c("a,b", "c,d"))

  expect_snapshot_lazy(
    df |> separate_longer_delim_polars(x, delim = ","),
    error = TRUE
  )
  expect_snapshot_lazy(
    df |> separate_longer_position_polars(x, width = 2),
    error = TRUE
  )
})

test_that("errors on non-existent column", {
  df <- pl$LazyFrame(
    id = 1:2,
    x = c("a,b", "c,d")
  )

  expect_snapshot_lazy(
    df |> separate_longer_delim_polars(nonexistent, delim = ","),
    error = TRUE
  )

  expect_snapshot_lazy(
    df |> separate_longer_position_polars(nonexistent, width = 2),
    error = TRUE
  )
})

test_that("errors when cols is missing", {
  df <- pl$LazyFrame(
    id = 1:2,
    x = c("a,b", "c,d")
  )

  expect_snapshot_lazy(
    df |> separate_longer_delim_polars(delim = ","),
    error = TRUE
  )

  expect_snapshot_lazy(
    df |> separate_longer_position_polars(width = 2),
    error = TRUE
  )
})

test_that("errors when delim is missing", {
  df <- pl$LazyFrame(
    id = 1:2,
    x = c("a,b", "c,d")
  )

  expect_snapshot_lazy(
    df |> separate_longer_delim_polars(x),
    error = TRUE
  )
})

test_that("errors when width is missing", {
  df <- pl$LazyFrame(
    id = 1:2,
    x = c("a,b", "c,d")
  )

  expect_snapshot_lazy(
    df |> separate_longer_position_polars(x),
    error = TRUE
  )
})

test_that("errors when width is invalid", {
  df <- pl$LazyFrame(
    id = 1:2,
    x = c("ab", "cd")
  )

  expect_snapshot_lazy(
    df |> separate_longer_position_polars(x, width = 0),
    error = TRUE
  )

  expect_snapshot_lazy(
    df |> separate_longer_position_polars(x, width = 1.5),
    error = TRUE
  )
})

test_that("errors when ... is not empty", {
  df <- pl$LazyFrame(
    id = 1:2,
    x = c("a,b", "c,d")
  )

  expect_snapshot_lazy(
    df |> separate_longer_delim_polars(x, delim = ",", extra = TRUE),
    error = TRUE
  )

  expect_snapshot_lazy(
    df |> separate_longer_position_polars(x, width = 2, extra = TRUE),
    error = TRUE
  )
})

# Error when n to m (n, m >= 2, n != m) - incompatible lengths
test_that("separate_longer_delim_polars errors on incompatible lengths", {
  df <- pl$LazyFrame(
    id = 1:2,
    x = c("a,b,c", "d,e"),
    y = c("1,2", "3,4,5,6")
  )

  expect_equal_or_both_error(
    df |> separate_longer_delim_polars(c(x, y), delim = ","),
    as.data.frame(df) |> tidyr::separate_longer_delim(c(x, y), delim = ",")
  )
})

# Error when n to m (n, m >= 2, n != m) - incompatible lengths
test_that("separate_longer_position_polars errors on incompatible lengths", {
  df <- pl$LazyFrame(
    id = 1:4,
    x = c("a", "bc", "def", "gh"),
    y = c("12", "345", "6789012", "")
  )

  expect_equal_or_both_error(
    df |> separate_longer_position_polars(c(x, y), width = 2),
    as.data.frame(df) |> tidyr::separate_longer_position(c(x, y), width = 2)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
