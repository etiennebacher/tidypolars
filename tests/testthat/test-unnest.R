test_that("unnest_longer_polars returns custom class", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    values = list(c(1, 2), c(3, 4, 5), 6)
  )
  expect_is_tidypolars(unnest_longer_polars(df, values))
})

test_that("basic unnest works", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    values = list(c(1, 2), c(3, 4, 5), 6)
  )

  result <- unnest_longer_polars(df, values)

  expect_dim(result, c(6, 2))
  expect_colnames(result, c("id", "values"))

  # Check values are correctly expanded
  expect_equal(
    as.data.frame(result)$values,
    c(1, 2, 3, 4, 5, 6)
  )
  expect_equal(
    as.data.frame(result)$id,
    c(1L, 1L, 2L, 2L, 2L, 3L)
  )
})

test_that("unnest with values_to works", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )

  result <- unnest_longer_polars(df, values, values_to = "val")

  expect_colnames(result, c("id", "val"))
  expect_equal(
    as.data.frame(result)$val,
    c(1, 2, 3, 4)
  )
})

test_that("unnest with indices_to works", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(10, 20), c(30, 40, 50))
  )

  result <- unnest_longer_polars(df, values, indices_to = "idx")

  expect_colnames(result, c("id", "values", "idx"))
  expect_dim(result, c(5, 3))

  # Check that indices are 1-indexed within each group
  expect_equal(
    as.data.frame(result)$idx,
    c(1L, 2L, 1L, 2L, 3L)
  )
})

test_that("unnest with both values_to and indices_to works", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(10, 20), c(30, 40, 50))
  )

  result <- unnest_longer_polars(
    df,
    values,
    values_to = "val",
    indices_to = "idx"
  )

  expect_colnames(result, c("id", "val", "idx"))
  expect_equal(
    as.data.frame(result)$val,
    c(10, 20, 30, 40, 50)
  )
  expect_equal(
    as.data.frame(result)$idx,
    c(1L, 2L, 1L, 2L, 3L)
  )
})

test_that("keep_empty = FALSE drops NULL values", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    values = list(c(1, 2), NULL, 3)
  )

  result <- unnest_longer_polars(df, values, keep_empty = FALSE)

  # NULL row should be dropped
  expect_dim(result, c(3, 2))
  expect_equal(
    as.data.frame(result)$id,
    c(1L, 1L, 3L)
  )
})

test_that("keep_empty = TRUE keeps NULL values as NA", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    values = list(c(1, 2), NULL, 3)
  )

  result <- unnest_longer_polars(df, values, keep_empty = TRUE)

  # NULL row should be kept as NA
  expect_dim(result, c(4, 2))
  expect_equal(
    as.data.frame(result)$id,
    c(1L, 1L, 2L, 3L)
  )
  expect_true(is.na(as.data.frame(result)$values[3]))
})

test_that("unnest works with string list columns", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    tags = c("apple,banana", "grape,pear")
  )$with_columns(
    pl$col("tags")$str$split(",")$alias("tags_list")
  )

  result <- unnest_longer_polars(df, tags_list)

  expect_dim(result, c(4, 3))
  expect_equal(
    as.data.frame(result)$tags_list,
    c("apple", "banana", "grape", "pear")
  )
  expect_equal(
    as.data.frame(result)$id,
    c(1L, 1L, 2L, 2L)
  )
})

test_that("column can be specified as string", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )

  result <- unnest_longer_polars(df, "values")

  expect_dim(result, c(4, 2))
})

test_that("multiple columns can be unnested together", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    a = list(c(1, 2), c(3, 4), c(5, 7, 6)),
    b = list(c("x", "y"), c("z", "w"), c("u", "v", "w"))
  )

  result <- unnest_longer_polars(df, c(a, b))

  expect_dim(result, c(7, 3))
  expect_colnames(result, c("id", "a", "b"))
  expect_equal(
    as.data.frame(result)$a,
    c(1, 2, 3, 4, 5, 7, 6)
  )
  expect_equal(
    as.data.frame(result)$b,
    c("x", "y", "z", "w", "u", "v", "w")
  )
  expect_equal(
    as.data.frame(result)$id,
    c(1L, 1L, 2L, 2L, 3L, 3L, 3L)
  )
})

test_that("chained unnest_longer works", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    a = list(1:2, 3:4),
    b = list(5:6, 7:8)
  )

  result <- df |>
    unnest_longer_polars(a) |>
    unnest_longer_polars(b)

  expect_dim(result, c(8, 3))
  expect_colnames(result, c("id", "a", "b"))

  result_df <- as.data.frame(result)
  expect_equal(result_df$id, c(1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L))
  expect_equal(result_df$a, c(1L, 1L, 2L, 2L, 3L, 3L, 4L, 4L))
  expect_equal(result_df$b, c(5L, 6L, 5L, 6L, 7L, 8L, 7L, 8L))
})

test_that("multiple columns can be specified as character vector", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    a = list(c(1, 2), c(3, 4)),
    b = list(c("x", "y"), c("z", "w"))
  )

  result <- unnest_longer_polars(df, c("a", "b"))

  expect_dim(result, c(4, 3))
  expect_colnames(result, c("id", "a", "b"))
  expect_equal(
    as.data.frame(result)$a,
    c(1, 2, 3, 4)
  )
  expect_equal(
    as.data.frame(result)$b,
    c("x", "y", "z", "w")
  )
})

test_that("multiple columns with indices_to works", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    a = list(c(1, 2), c(3, 4, 5)),
    b = list(c("x", "y"), c("z", "w", "v"))
  )

  result <- unnest_longer_polars(df, c(a, b), indices_to = "idx")

  expect_dim(result, c(5, 4))
  expect_colnames(result, c("id", "a", "b", "idx"))
  expect_equal(
    as.data.frame(result)$idx,
    c(1L, 2L, 1L, 2L, 3L)
  )
})

test_that("values_to errors with multiple columns without template", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    a = list(1:2, 3:4),
    b = list(5:6, 7:8)
  )

  expect_error(
    unnest_longer_polars(df, c(a, b), values_to = "val"),
    "must contain"
  )
})

test_that("values_to template works with multiple columns", {
  df <- polars::pl$DataFrame(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )

  result <- unnest_longer_polars(df, c(y, z), values_to = "{col}_val")

  expect_dim(result, c(4, 3))
  expect_colnames(result, c("x", "y_val", "z_val"))
  expect_equal(as.data.frame(result)$y_val, c(1L, 2L, 3L, 4L))
  expect_equal(as.data.frame(result)$z_val, c(5L, 6L, 7L, 8L))
})

test_that("indices_to template works with multiple columns", {
  df <- polars::pl$DataFrame(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )

  result <- unnest_longer_polars(df, c(y, z), indices_to = "{col}_idx")

  expect_dim(result, c(4, 5))
  expect_colnames(result, c("x", "y", "z", "y_idx", "z_idx"))
  expect_equal(as.data.frame(result)$y_idx, c(1L, 2L, 1L, 2L))
  expect_equal(as.data.frame(result)$z_idx, c(1L, 2L, 1L, 2L))
})

test_that("both values_to and indices_to templates work together", {
  df <- polars::pl$DataFrame(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )

  result <- unnest_longer_polars(
    df,
    c(y, z),
    values_to = "{col}_val",
    indices_to = "{col}_idx"
  )

  expect_dim(result, c(4, 5))
  expect_colnames(result, c("x", "y_val", "z_val", "y_idx", "z_idx"))
  expect_equal(as.data.frame(result)$y_val, c(1L, 2L, 3L, 4L))
  expect_equal(as.data.frame(result)$z_val, c(5L, 6L, 7L, 8L))
  expect_equal(as.data.frame(result)$y_idx, c(1L, 2L, 1L, 2L))
  expect_equal(as.data.frame(result)$z_idx, c(1L, 2L, 1L, 2L))
})

test_that("values_to template with dash separator works", {
  df <- polars::pl$DataFrame(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )

  result <- unnest_longer_polars(df, c(y, z), values_to = "{col}-n")

  expect_colnames(result, c("x", "y-n", "z-n"))
  expect_equal(as.data.frame(result)$`y-n`, c(1L, 2L, 3L, 4L))
  expect_equal(as.data.frame(result)$`z-n`, c(5L, 6L, 7L, 8L))
})

test_that("errors on non-polars data", {
  df <- data.frame(id = 1:2, values = I(list(1:2, 3:4)))

  expect_error(
    unnest_longer_polars(df, values),
    "must be a Polars DataFrame or LazyFrame"
  )
})

test_that("errors on non-existent column", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )

  expect_error(
    unnest_longer_polars(df, nonexistent),
    class = "vctrs_error_subscript_oob"
  )
})

test_that("errors when ... is not empty", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )

  expect_error(
    unnest_longer_polars(df, values, extra_arg = TRUE),
    class = "rlib_error_dots_nonempty"
  )
})
