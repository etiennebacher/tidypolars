test_that("basic behavior works", {
  l <- list(
    polars0::pl$DataFrame(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    ),
    polars0::pl$DataFrame(
      x = sample(letters, 20),
      y = sample.int(100, 20)
    )
  )

  expect_is_tidypolars(bind_rows_polars(l))

  expect_dim(
    bind_rows_polars(l),
    c(40, 2)
  )
})

test_that("dots and list are equivalent", {
  p1 <- pl$DataFrame(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  p2 <- pl$DataFrame(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )

  expect_equal(
    bind_rows_polars(p1, p2),
    bind_rows_polars(list(p1, p2))
  )
})

test_that("different dtypes work", {
  l <- list(
    polars0::pl$DataFrame(
      x = c("a", "b"),
      y = 1:2
    ),
    polars0::pl$DataFrame(
      y = 3:4,
      z = c("c", "d")
    )$with_columns(pl$col("y")$cast(pl$Int16))
  )

  expect_equal(
    bind_rows_polars(l),
    data.frame(
      x = c("a", "b", NA, NA),
      y = 1:4,
      z = c(NA, NA, "c", "d")
    )
  )
})

test_that("arg .id works", {
  p1 <- pl$DataFrame(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  p2 <- pl$DataFrame(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )

  expect_equal(
    bind_rows_polars(p1, p2, .id = "foo") |>
      pull(foo),
    as.character(rep(1:2, each = 20))
  )

  expect_equal(
    bind_rows_polars(p1 = p1, p2 = p2, .id = "foo") |>
      pull(foo),
    rep(c("p1", "p2"), each = 20)
  )

  expect_equal(
    bind_rows_polars(list(p1 = p1, p2 = p2), .id = "foo") |>
      pull(foo),
    rep(c("p1", "p2"), each = 20)
  )

  expect_equal(
    bind_rows_polars(p1 = p1, p2, .id = "foo") |>
      pull(foo),
    as.character(rep(1:2, each = 20))
  )
})

test_that("error if not all elements don't have the same class", {
  p1 <- pl$DataFrame(
    x = sample(letters, 20),
    y = sample.int(100, 20)
  )
  p2 <- data.frame(
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
