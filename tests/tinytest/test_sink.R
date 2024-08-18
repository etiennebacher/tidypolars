source("helpers.R")
using("tidypolars")

# error if not a Polars LazyFrame

expect_error(
  sink_csv(mtcars),
  "can only be used on a LazyFrame"
)

expect_error(
  sink_parquet(mtcars),
  "can only be used on a LazyFrame"
)

# -----------------------------------------------

exit_if_not(requireNamespace("jsonlite"))
exit_if_not(requireNamespace("nanoparquet"))

# CSV

dest <- tempfile(fileext = ".csv")
mtcars |>
  as_polars_lf() |>
  sink_csv(dest)

expect_equal(read.csv(dest), mtcars, check.attributes = FALSE)

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
# expect_equal(jsonlite::fromJSON(dest), mtcars, check.attributes = FALSE)

# NDJSON

# dest <- tempfile(fileext = ".ndjson")
# mtcars |>
#   as_polars_lf() |>
#   write_ndjson_polars(dest)
#
# expect_equal(
#   suppressMessages(jsonlite::stream_in(file(dest), verbose = FALSE)),
#   mtcars,
#   check.attributes = FALSE
# )

# Parquet

dest <- tempfile(fileext = ".parquet")
mtcars |>
  as_polars_lf() |>
  sink_parquet(dest)

expect_equal(nanoparquet::read_parquet(dest), mtcars, check.attributes = FALSE)
