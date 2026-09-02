test_that("can only be used on a lazyframe", {
  expect_snapshot(sink_csv(mtcars), error = TRUE)
  expect_snapshot(sink_parquet(mtcars), error = TRUE)
  expect_snapshot(sink_ndjson(mtcars), error = TRUE)
  expect_snapshot(sink_ipc(mtcars), error = TRUE)
})

test_that("basic behavior with CSV", {
  dest <- tempfile(fileext = ".csv")
  mtcars |>
    as_polars_lf() |>
    sink_csv(dest)

  expect_equal(read.csv(dest), mtcars, ignore_attr = TRUE)
})

test_that("sink_csv accepts the 'never' quote style", {
  dest <- tempfile(fileext = ".csv")
  as_polars_lf(tibble(x = c("a,b", "c"))) |>
    sink_csv(dest, quote_style = "never")

  expect_equal(readLines(dest), c("x", "a,b", "c"))
})

test_that("sink_csv() works with null_value", {
  dat <- as_polars_lf(data.frame(x = c(1, NA), y = c(1, 2)))

  dest <- tempfile(fileext = ".csv")
  sink_csv(dat, dest, null_value = "NEW")
  expect_identical(read.csv(dest)[2, "x"], "NEW")
})

test_that("basic behavior with parquet", {
  skip_if_not_installed("nanoparquet")
  dest <- tempfile(fileext = ".parquet")
  mtcars |>
    as_polars_lf() |>
    sink_parquet(dest)

  expect_equal(nanoparquet::read_parquet(dest), mtcars, ignore_attr = TRUE)
})

test_that("basic behavior with IPC", {
  dest <- tempfile(fileext = ".arrow")
  mtcars |>
    as_polars_lf() |>
    sink_ipc(dest)

  expect_equal(arrow::read_ipc_file(dest), mtcars, ignore_attr = TRUE)
})

test_that("basic behavior with NDJSON", {
  skip_if_not_installed("jsonlite")
  dest <- tempfile(fileext = ".ndjson")
  mtcars |>
    as_polars_lf() |>
    sink_ndjson(dest)

  expect_equal(
    suppressMessages(jsonlite::stream_in(file(dest), verbose = FALSE)),
    mtcars,
    ignore_attr = TRUE
  )
})
