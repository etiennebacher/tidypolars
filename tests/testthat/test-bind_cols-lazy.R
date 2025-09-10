### [GENERATED AUTOMATICALLY] Update test-bind_cols.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("returns custom class", {
  l <- list(
    polars::pl$LazyFrame(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    polars::pl$LazyFrame(
      a = sample(letters, 20),
      z = sample.int(100, 20)
    )
  )

  expect_is_tidypolars(bind_cols_polars(l))
})

test_that("basic behavior with list works", {
  l <- list(
    polars::pl$LazyFrame(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    polars::pl$LazyFrame(
      a = sample(letters, 20),
      z = sample.int(100, 20)
    )
  )
  expect_dim(
    bind_cols_polars(l),
    c(20, 4)
  )
})

test_that("passing individual elements works", {
  p1 <- pl$LazyFrame(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  p2 <- pl$LazyFrame(
    z = sample(letters, 20),
    w = sample.int(100, 20)
  )

  expect_equal_lazy(
    bind_cols_polars(p1, p2),
    bind_cols_polars(list(p1, p2))
  )
})

test_that("error if not all elements don't have the same class", {
  l <- list(
    data.frame(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    polars::pl$LazyFrame(
      y = sample(letters, 20),
      z = sample.int(100, 20)
    )
  )

  expect_snapshot_lazy(
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
    polars::pl$LazyFrame(
      y = sample(letters, 20),
      z = sample.int(100, 20)
    )
  )

  expect_snapshot_lazy(
    bind_cols_polars(l),
    error = TRUE
  )
})

test_that("can only bind more than 2 elements if DataFrame", {
  l <- list(
    polars::pl$LazyFrame(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    polars::pl$LazyFrame(
      a = sample(letters, 20),
      z = sample.int(100, 20)
    ),
    polars::pl$LazyFrame(
      v = sample(letters, 20),
      w = sample.int(100, 20)
    )
  )

  expect_dim(bind_cols_polars(l), c(20, 6))

  expect_colnames(
    bind_cols_polars(l),
    c("x", "y", "a", "z", "v", "w")
  )
})

test_that("arg .name_repair works", {
  skip_if_not_installed("withr")
  withr::local_options(rlib_message_verbosity = "quiet")

  l <- list(
    pl$LazyFrame(a = 1, x = 2, y = 3),
    pl$LazyFrame(z = 1, x = 2, y = 3)
  )

  expect_named(
    bind_cols_polars(l),
    c("a", "x...2", "y...3", "z", "x...5", "y...6")
  )

  expect_named(
    bind_cols_polars(l, .name_repair = "universal"),
    c("a", "x...2", "y...3", "z", "x...5", "y...6")
  )

  expect_snapshot_lazy(
    bind_cols_polars(l, .name_repair = "check_unique"),
    error = TRUE
  )
  expect_snapshot_lazy(
    bind_cols_polars(l, .name_repair = "minimal"),
    error = TRUE
  )
  expect_snapshot_lazy(
    bind_cols_polars(l, .name_repair = "blahblah"),
    error = TRUE
  )
})

test_that("arg .name_repair works", {
  skip_if_not_installed("withr")
  withr::local_options(rlib_message_verbosity = "quiet")

  l <- list(
    pl$LazyFrame(x = 1)$rename(x = " "),
    pl$LazyFrame(x = 1)$rename(x = " ")
  )

  expect_named(bind_cols_polars(l), c(" ...1", " ...2"))

  expect_named(
    bind_cols_polars(l, .name_repair = "universal"),
    c("....1", "....2")
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
