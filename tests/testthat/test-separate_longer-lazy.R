### [GENERATED AUTOMATICALLY] Update test-separate_longer.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("separate_longer_delim_polars returns custom class", {
  df <- polars::pl$LazyFrame(
    id = 1:3,
    x = c("a,b,c", "d,e", "f")
  )
  expect_is_tidypolars(df |> separate_longer_delim_polars(x, delim = ","))
})

test_that("separate_longer_delim_polars basic functionality", {
  df <- polars::pl$LazyFrame(
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

test_that("separate_longer_delim_polars mulit delims in text", {
  df <- polars::pl$LazyFrame(
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

test_that("separate_longer_delim_polars with empty string as delim", {
  df <- polars::pl$LazyFrame(
    id = 1:3,
    x = c("abc", "de", "f")
  )

  target_df <- polars::pl$LazyFrame(
    id = c(1L, 1L, 1L, 2L, 2L, 3L),
    x = c("a", "b", "c", "d", "e", "f")
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(x, delim = ""),
    target_df
  )
})

test_that("separate_longer_delim_polars works with multiple columns", {
  df <- polars::pl$LazyFrame(
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

# TODO:
# 1 to n; n to 1; n to n 都是可以的
test_that("separate_longer_delim_polars works with not matched multiple columns", {
  df <- polars::pl$LazyFrame(
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
  df <- polars::pl$LazyFrame(
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

test_that("separate_longer_position_polars returns custom class", {
  df <- polars::pl$LazyFrame(
    id = 1:3,
    x = c("abcd", "efgh", "ij")
  )
  expect_is_tidypolars(df |> separate_longer_position_polars(x, width = 2))
})

test_that("separate_longer_position_polars basic functionality", {
  df <- polars::pl$LazyFrame(
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
  df <- polars::pl$LazyFrame(
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
  df <- polars::pl$LazyFrame(
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
  df <- polars::pl$LazyFrame(
    id = 1:3,
    x = c("abcd", NA, "ef")
  )

  # tidyr::separate_longer_position errors on NA values,
  # but Polars handles it by keeping NA as is.
  # I think keeping NA is the correct behavior, the same as delim version.
  # Maybe this is a bug in tidyr, because tidyr::separate_longer_delim keeps NA.
  result <- df |>
    separate_longer_position_polars(x, width = 2) |>
    as.data.frame()

  expect_equal_lazy(nrow(result), 4)
  expect_true(is.na(result$x[3]))
})


test_that("separate_longer_position_polars works with multiple columns", {
  df <- polars::pl$LazyFrame(
    id = 1:6,
    x = c("abcd", "efg", "hi", "j", "", NA),
    y = c("1234", "567", "89", "0", "", NA)
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(c(x, y), width = 2),
    as.data.frame(df) |>
      tidyr::separate_longer_position(c(x, y), width = 2) |>
      as.data.frame()
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(c(x, y), width = 3),
    as.data.frame(df) |>
      tidyr::separate_longer_position(c(x, y), width = 3) |>
      as.data.frame()
  )
})

# TODO
# 对于切分长度大于字符串长度的情况，tidyr会保留原字符串并重复，并对其他列继续切分
test_that("separate_longer_position_polars works with matched nrow and multiple columns", {
  df <- polars::pl$LazyFrame(
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

  df_2 <- polars::pl$LazyFrame(
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

# Error tests
test_that("errors on non-polars data", {
  df <- data.frame(id = 1:2, x = c("a,b", "c,d"))
  df_tibble <- tibble::tibble(id = 1:2, x = c("a,b", "c,d"))

  expect_snapshot_lazy(
    df |> separate_longer_delim_polars(x, delim = ","),
    error = TRUE
  )
  expect_snapshot_lazy(
    df |> separate_longer_position_polars(x, width = 2),
    error = TRUE
  )

  expect_snapshot_lazy(
    df_tibble |> separate_longer_delim_polars(x, delim = ","),
    error = TRUE
  )
  expect_snapshot_lazy(
    df_tibble |> separate_longer_position_polars(x, width = 2),
    error = TRUE
  )
})

# TODO
# tidyr是什么也不做，而polars会报错
test_that("errors on non-string column", {
  df <- polars::pl$LazyFrame(
    id = 1:3,
    x = c(1, 2, 3)
  )

  expect_equal_lazy(
    df |> separate_longer_delim_polars(x, delim = ",") |> as.data.frame(),
    as.data.frame(df)
  )

  expect_equal_lazy(
    df |> separate_longer_position_polars(x, width = 2) |> as.data.frame(),
    as.data.frame(df)
  )
})

test_that("errors on non-existent column", {
  df <- polars::pl$LazyFrame(
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
  df <- polars::pl$LazyFrame(
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
  df <- polars::pl$LazyFrame(
    id = 1:2,
    x = c("a,b", "c,d")
  )

  expect_snapshot_lazy(
    df |> separate_longer_delim_polars(x),
    error = TRUE
  )
})

test_that("errors when width is missing", {
  df <- polars::pl$LazyFrame(
    id = 1:2,
    x = c("a,b", "c,d")
  )

  expect_snapshot_lazy(
    df |> separate_longer_position_polars(x),
    error = TRUE
  )
})

test_that("errors when width is invalid", {
  df <- polars::pl$LazyFrame(
    id = 1:2,
    x = c("ab", "cd")
  )

  expect_snapshot_lazy(
    separate_longer_position_polars(df, x, width = 0),
    error = TRUE
  )

  expect_snapshot_lazy(
    separate_longer_position_polars(df, x, width = -1),
    error = TRUE
  )

  expect_snapshot_lazy(
    separate_longer_position_polars(df, x, width = 1.5),
    error = TRUE
  )
})

test_that("errors when ... is not empty", {
  df <- polars::pl$LazyFrame(
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

# TODO:
# n to m 是不可以的
test_that("separate_longer_delim_polars works with not matched multiple columns", {
  df <- polars::pl$LazyFrame(
    id = 1:2,
    x = c("a,b,c", "d,e"),
    y = c("1,2", "3,4,5,6")
  )

  expect_snapshot_lazy(
    df |> separate_longer_delim_polars(c(x, y), delim = ","),
    error = TRUE
  )
})

# TODO:
# n to m 是不可以的
test_that("separate_longer_position_polars error when nrow not match with multiple columns", {
  df <- polars::pl$LazyFrame(
    id = 1:4,
    x = c("a", "bc", "def", "gh"),
    y = c("12", "345", "67890", "")
  )

  expect_snapshot_lazy(
    df |> separate_longer_position_polars(c(x, y), width = 1),
    error = TRUE
  )

  expect_snapshot_lazy(
    df |> separate_longer_position_polars(c(x, y), width = 2),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
