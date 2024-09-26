test_that("only works on polars dataframe", {
  expect_error(
    write_csv_polars(mtcars),
    "can only be used on a DataFrame"
  )

  expect_error(
    write_ipc_polars(mtcars),
    "can only be used on a DataFrame"
  )

  expect_error(
    write_json_polars(mtcars),
    "can only be used on a DataFrame"
  )

  expect_error(
    write_ndjson_polars(mtcars),
    "can only be used on a DataFrame"
  )

  expect_error(
    write_parquet_polars(mtcars),
    "can only be used on a DataFrame"
  )
})

test_that("basic behavior with CSV", {
  dest <- tempfile(fileext = ".csv")
  mtcars |>
    as_polars_df() |>
    write_csv_polars(dest)

  expect_equal(read.csv(dest), mtcars, ignore_attr = TRUE)
  expect_s3_class(read_csv_polars(dest), "RPolarsDataFrame")
})

# IPC

# TODO:
# dest <- tempfile(fileext = ".arrow")
# mtcars |>
#   as_polars_df() |>
#   write_ipc_polars(dest)
#
# arrow::read_ipc_file(dest)


test_that("basic behavior with JSON", {
  dest <- tempfile(fileext = ".json")
  mtcars |>
    as_polars_df() |>
    write_json_polars(dest, row_oriented = TRUE)
  
  expect_equal(jsonlite::fromJSON(dest), mtcars, ignore_attr = TRUE) 
})

test_that("basic behavior with NDJSON", {
  dest <- tempfile(fileext = ".ndjson")
  mtcars |>
    as_polars_df() |>
    write_ndjson_polars(dest)

  expect_equal(
    suppressMessages(jsonlite::stream_in(file(dest), verbose = FALSE)),
    mtcars,
    ignore_attr = TRUE
  )
  expect_s3_class(read_ndjson_polars(dest), "RPolarsDataFrame")
})

test_that("basic behavior with Parquet", {
  dest <- tempfile(fileext = ".parquet")
  mtcars |>
    as_polars_df() |>
    write_parquet_polars(dest)

  expect_equal(nanoparquet::read_parquet(dest), mtcars, ignore_attr = TRUE)
  expect_s3_class(read_parquet_polars(dest), "RPolarsDataFrame")
})
