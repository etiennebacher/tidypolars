test_that("basic behavior works", {
  l <- list(
    tibble(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    tibble(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    )
  )
  l_pl <- lapply(l, as_polars_df)

  expect_is_tidypolars(bind_rows_polars(l_pl))
  expect_equal(
    bind_rows_polars(l_pl),
    bind_rows(l)
  )
})

test_that("dots and list are equivalent", {
  df1 <- tibble(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  df2 <- tibble(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  df1_pl <- as_polars_df(df1)
  df2_pl <- as_polars_df(df2)

  expect_equal(
    bind_rows_polars(df1_pl, df2_pl),
    bind_rows(df1, df2)
  )
  expect_equal(
    bind_rows_polars(list(df1_pl, df2_pl)),
    bind_rows(list(df1, df2))
  )
})

test_that("different dtypes work", {
  df1 <- tibble(x = c("a", "b"), y = 1:2)
  df2 <- tibble(y = 3:4, z = c("c", "d"))
  df1_pl <- as_polars_df(df1)
  df2_pl <- as_polars_df(df2)
  l <- list(df1_pl, df2_pl$with_columns(pl$col("y")$cast(pl$Int16)))

  expect_equal(
    bind_rows_polars(l),
    bind_rows(df1, df2)
  )
})

test_that("arg .id works", {
  df1 <- tibble(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  df2 <- tibble(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  df1_pl <- as_polars_df(df1)
  df2_pl <- as_polars_df(df2)

  expect_equal(
    bind_rows_polars(df1_pl, df2_pl, .id = "foo"),
    bind_rows(df1, df2, .id = "foo")
  )

  expect_equal(
    bind_rows_polars(df1 = df1_pl, df2 = df2_pl, .id = "foo"),
    bind_rows(df1 = df1, df2 = df2, .id = "foo")
  )

  expect_equal(
    bind_rows_polars(list(df1 = df1_pl, df2 = df2_pl), .id = "foo"),
    bind_rows(list(df1 = df1, df2 = df2), .id = "foo")
  )

  expect_equal(
    bind_rows_polars(df1 = df1_pl, df2_pl, .id = "foo"),
    bind_rows(df1 = df1, df2, .id = "foo")
  )
})

test_that("error if not all elements don't have the same class", {
  p1 <- pl$DataFrame(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  p2 <- tibble(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )

  expect_snapshot(bind_rows_polars(p1, p2), error = TRUE)
})

test_that("elements must be either all DataFrames or all LazyFrames", {
  skip_if(Sys.getenv("TIDYPOLARS_TEST") == "TRUE")
  p1 <- pl$DataFrame(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  p2 <- pl$LazyFrame(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )

  expect_snapshot(bind_rows_polars(p1, p2), error = TRUE)
})
