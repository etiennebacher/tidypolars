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

test_that("basic behavior with parquet", {
  skip_if_not_installed("nanoparquet")
  dest <- tempfile(fileext = ".parquet")
  mtcars |>
    as_polars_lf() |>
    sink_parquet(dest)

  expect_equal(nanoparquet::read_parquet(dest), mtcars, ignore_attr = TRUE)
})

test_that("basic behavior with IPC", {
  skip_if_not_installed("arrow")
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
