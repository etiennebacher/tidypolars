test_that("only works on polars dataframe", {
  expect_snapshot(
    write_csv_polars(mtcars),
    error = TRUE
  )
  expect_snapshot(
    write_ipc_polars(mtcars),
    error = TRUE
  )
  expect_snapshot(
    write_json_polars(mtcars),
    error = TRUE
  )
  expect_snapshot(
    write_ndjson_polars(mtcars),
    error = TRUE
  )
  expect_snapshot(
    write_parquet_polars(mtcars),
    error = TRUE
  )
})

test_that("basic behavior with CSV", {
  dest <- tempfile(fileext = ".csv")
  mtcars |>
    as_polars_df() |>
    write_csv_polars(dest)

  expect_equal(read.csv(dest), mtcars, ignore_attr = TRUE)
  expect_s3_class(read_csv_polars(dest), "polars_data_frame")
})

test_that("write_csv_polars() resolves null_value and null_values correctly", {
  dat <- as_polars_df(data.frame(x = c(1, NA), y = c(1, 2)))

  dest <- tempfile(fileext = ".csv")
  write_csv_polars(dat, dest, null_value = "NEW")
  expect_identical(read.csv(dest)[2, "x"], "NEW")
})

test_that("basic behavior with IPC", {
  skip_if_not_installed("arrow")
  dest <- tempfile(fileext = ".arrow")
  mtcars |>
    as_polars_df() |>
    write_ipc_polars(dest)

  expect_equal(arrow::read_ipc_file(dest), mtcars, ignore_attr = TRUE)
  expect_s3_class(read_ipc_polars(dest), "polars_data_frame")
})

test_that("basic behavior with JSON", {
  skip_if_not_installed("jsonlite")
  dest <- tempfile(fileext = ".json")
  mtcars |>
    as_polars_df() |>
    write_json_polars(dest)

  expect_equal(jsonlite::fromJSON(dest), mtcars, ignore_attr = TRUE)
})

test_that("basic behavior with NDJSON", {
  skip_if_not_installed("jsonlite")
  dest <- tempfile(fileext = ".ndjson")
  mtcars |>
    as_polars_df() |>
    write_ndjson_polars(dest)

  expect_equal(
    suppressMessages(jsonlite::stream_in(file(dest), verbose = FALSE)),
    mtcars,
    ignore_attr = TRUE
  )
  expect_s3_class(read_ndjson_polars(dest), "polars_data_frame")
})

test_that("basic behavior with Parquet", {
  skip_if_not_installed("nanoparquet")
  dest <- tempfile(fileext = ".parquet")
  mtcars |>
    as_polars_df() |>
    write_parquet_polars(dest)

  expect_equal(nanoparquet::read_parquet(dest), mtcars, ignore_attr = TRUE)
  expect_s3_class(read_parquet_polars(dest), "polars_data_frame")
})

test_that("write_parquet: mkdir works", {
  dest_dir <- withr::local_tempdir()
  dest <- file.path(dest_dir, "another_folder", "foo.parquet")
  dat <- as_polars_df(mtcars)

  # Error message is OS-dependent
  expect_error(write_parquet_polars(dat, dest))
  expect_silent(
    write_parquet_polars(dat, dest, mkdir = TRUE)
  )
})
