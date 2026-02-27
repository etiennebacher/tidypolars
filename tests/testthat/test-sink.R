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

test_that("deprecated args in sink_csv()", {
  dest <- tempfile(fileext = ".csv")
  dat <- as_polars_lf(mtcars)

  expect_snapshot({
    x <- sink_csv(dat, dest, null_values = "a")
  })
  expect_snapshot({
    x <- sink_csv(dat, dest, quote = "a")
  })
})

test_that("sink_csv() resolves null_value and null_values correctly", {
  dat <- as_polars_lf(data.frame(x = c(1, NA), y = c(1, 2)))

  dest_old <- tempfile(fileext = ".csv")
  expect_warning(
    sink_csv(dat, dest_old, null_values = "OLD"),
    "deprecated"
  )
  expect_identical(read.csv(dest_old)[2, "x"], "OLD")

  dest_both <- tempfile(fileext = ".csv")
  expect_warning(
    sink_csv(dat, dest_both, null_value = "NEW", null_values = "OLD"),
    "deprecated"
  )
  expect_identical(read.csv(dest_both)[2, "x"], "NEW")
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
