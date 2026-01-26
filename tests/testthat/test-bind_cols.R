test_that("returns custom class", {
  l <- list(
    polars::pl$DataFrame(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    polars::pl$DataFrame(
      a = sample(letters, 20),
      z = sample.int(100, 20)
    )
  )

  expect_is_tidypolars(bind_cols_polars(l))
})

test_that("basic behavior with list works", {
  l <- list(
    tibble(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    tibble(
      a = sample(letters, 20),
      z = sample.int(100, 20)
    )
  )
  l_pl <- lapply(l, as_polars_df)

  expect_equal(
    bind_cols_polars(l_pl),
    bind_cols(l)
  )
})

test_that("dots and list are equivalent", {
  df1 <- tibble(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  df2 <- tibble(
    z = sample(letters, 20),
    w = sample.int(100, 20)
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

test_that("error if not all elements don't have the same class", {
  l <- list(
    data.frame(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    polars::pl$DataFrame(
      y = sample(letters, 20),
      z = sample.int(100, 20)
    )
  )

  expect_snapshot(
    bind_cols_polars(l),
    error = TRUE
  )
})

test_that("elements must be either all DataFrames or all LazyFrames", {
  skip_if(Sys.getenv("TIDYPOLARS_TEST") == "TRUE")
  l <- list(
    polars::pl$LazyFrame(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    polars::pl$DataFrame(
      y = sample(letters, 20),
      z = sample.int(100, 20)
    )
  )

  expect_snapshot(
    bind_cols_polars(l),
    error = TRUE
  )
})

test_that("can only bind more than 2 elements if DataFrame", {
  l <- list(
    tibble(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    tibble(
      a = sample(letters, 20),
      z = sample.int(100, 20)
    ),
    tibble(
      v = sample(letters, 20),
      w = sample.int(100, 20)
    )
  )
  l_pl <- lapply(l, as_polars_df)
  expect_equal(
    bind_cols_polars(l_pl),
    bind_cols(l)
  )
})

test_that("arg .name_repair works", {
  skip_if_not_installed("withr")
  withr::local_options(rlib_message_verbosity = "quiet")

  l <- list(
    pl$DataFrame(a = 1, x = 2, y = 3),
    pl$DataFrame(z = 1, x = 2, y = 3)
  )

  expect_named(
    bind_cols_polars(l),
    c("a", "x...2", "y...3", "z", "x...5", "y...6")
  )

  expect_named(
    bind_cols_polars(l, .name_repair = "universal"),
    c("a", "x...2", "y...3", "z", "x...5", "y...6")
  )

  expect_snapshot(
    bind_cols_polars(l, .name_repair = "check_unique"),
    error = TRUE
  )
  expect_snapshot(
    bind_cols_polars(l, .name_repair = "minimal"),
    error = TRUE
  )
  expect_snapshot(
    bind_cols_polars(l, .name_repair = "blahblah"),
    error = TRUE
  )
})

test_that("arg .name_repair works", {
  skip_if_not_installed("withr")
  withr::local_options(rlib_message_verbosity = "quiet")

  l <- list(
    pl$DataFrame(x = 1)$rename(x = " "),
    pl$DataFrame(x = 1)$rename(x = " ")
  )

  expect_named(bind_cols_polars(l), c(" ...1", " ...2"))

  expect_named(
    bind_cols_polars(l, .name_repair = "universal"),
    c("....1", "....2")
  )
})
