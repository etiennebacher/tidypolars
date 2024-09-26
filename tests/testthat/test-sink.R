test_that("can only be used on a lazyframe", {
  expect_error(
    sink_csv(mtcars),
    "can only be used on a LazyFrame"
  )

  expect_error(
    sink_parquet(mtcars),
    "can only be used on a LazyFrame"
  )
})

test_that("basic behavior with CSV", {
  dest <- tempfile(fileext = ".csv")
  mtcars |>
    as_polars_lf() |>
    sink_csv(dest)
  
  expect_equal(read.csv(dest), mtcars, ignore_attr = TRUE) 
})

test_that("basic behavior with parquet", {
  dest <- tempfile(fileext = ".parquet")
  mtcars |>
    as_polars_lf() |>
    sink_parquet(dest)

  expect_equal(nanoparquet::read_parquet(dest), mtcars, ignore_attr = TRUE)
})

# -----------------------------------------------

# exit_if_not(requireNamespace("jsonlite", quietly = TRUE))
# exit_if_not(requireNamespace("nanoparquet", quietly = TRUE))

# CSV

# IPC

# TODO:
# dest <- tempfile(fileext = ".arrow")
# mtcars |>
#   as_polars_lf() |>
#   write_ipc_polars(dest)
#
# arrow::read_ipc_file(dest)

# JSON

# dest <- tempfile(fileext = ".json")
# mtcars |>
#   as_polars_lf() |>
#   write_json_polars(dest, row_oriented = TRUE)
#
# expect_equal(jsonlite::fromJSON(dest), mtcars, ignore_attr = TRUE)

# NDJSON

# dest <- tempfile(fileext = ".ndjson")
# mtcars |>
#   as_polars_lf() |>
#   write_ndjson_polars(dest)
#
# expect_equal(
#   suppressMessages(jsonlite::stream_in(file(dest), verbose = FALSE)),
#   mtcars,
#   ignore_attr = TRUE
# )
