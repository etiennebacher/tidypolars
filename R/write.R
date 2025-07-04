#' Export data to CSV file(s)
#'
#' @param .data A Polars DataFrame.
#' @param file File path to which the result should be written.
#' @param ... Ignored.
#' @param include_bom Whether to include UTF-8 BOM (byte order mark) in the CSV
#' output.
#' @param include_header Whether to include header in the CSV output.
#' @param separator Separate CSV fields with this symbol.
#' @param line_terminator String used to end each row.
#' @param quote Byte to use as quoting character.
#' @param batch_size Number of rows that will be processed per thread.
#' @param datetime_format A format string, with the specifiers defined by the
#' chrono Rust crate. If no format specified, the default fractional-second
#' precision is inferred from the maximum timeunit found in the frame’s Datetime
#'  cols (if any).
#' @param date_format A format string, with the specifiers defined by the chrono
#' Rust crate.
#' @param time_format A format string, with the specifiers defined by the chrono
#' Rust crate.
#' @param float_precision Number of decimal places to write, applied to both
#' Float32 and Float64 datatypes.
#' @param null_values A string representing null values (defaulting to the empty
#' string).
#' @param quote_style Determines the quoting strategy used.
#' * `"necessary"` (default): This puts quotes around fields only when necessary.
#'   They are necessary when fields contain a quote, delimiter or record
#'   terminator. Quotes are also necessary when writing an empty record (which
#'   is indistinguishable from a record with one empty field). This is the
#'   default.
#' * `"always"`: This puts quotes around every field.
#' * `"non_numeric"`: This puts quotes around all fields that are non-numeric.
#'   Namely, when writing a field that does not parse as a valid float or integer,
#'   then quotes will be used even if they aren`t strictly necessary.
#' * `"never"`: This never puts quotes around fields, even if that results in
#'   invalid CSV data (e.g. by not quoting strings containing the separator).
#'
#' @return The input DataFrame.
#' @export
#'
#' @examples
#' dest <- tempfile(fileext = ".csv")
#' mtcars |>
#'   as_polars_df() |>
#'   write_csv_polars(dest)
#'
#' read.csv(dest)
write_csv_polars <- function(
  .data,
  file,
  ...,
  include_bom = FALSE,
  include_header = TRUE,
  separator = ",",
  line_terminator = "\n",
  quote = "\"",
  batch_size = 1024,
  datetime_format = NULL,
  date_format = NULL,
  time_format = NULL,
  float_precision = NULL,
  null_values = "",
  quote_style = "necessary"
) {
  if (!inherits(.data, "RPolarsDataFrame")) {
    cli_abort("{.fn write_csv_polars} can only be used on a DataFrame.")
  }

  rlang::arg_match0(
    quote_style,
    values = c("necessary", "always", "non_numeric", "never")
  )
  rlang::check_dots_empty()

  .data$write_csv(
    file,
    include_bom = include_bom,
    include_header = include_header,
    separator = separator,
    line_terminator = line_terminator,
    quote = quote,
    batch_size = batch_size,
    datetime_format = datetime_format,
    date_format = date_format,
    time_format = time_format,
    float_precision = float_precision,
    null_values = null_values,
    quote_style = quote_style
  )
}

#' Export data to Parquet file(s)
#'
#' @inheritParams write_csv_polars
#' @inheritParams sink_parquet
#' @param partition_by Column(s) to partition by. A partitioned dataset will be
#' written if this is specified.
#' @param partition_chunk_size_bytes Approximate size to split DataFrames within
#' a single partition when writing. Note this is calculated using the size of
#' the DataFrame in memory - the size of the output file may differ depending
#' on the file format / compression.
#'
#' @inherit write_csv_polars return
#' @export
#'
#' @examplesIf requireNamespace("nanoparquet")
#' dest <- tempfile(fileext = ".parquet")
#' mtcars |>
#'   as_polars_df() |>
#'   write_parquet_polars(dest)
#'
#' nanoparquet::read_parquet(dest)
write_parquet_polars <- function(
  .data,
  file,
  ...,
  compression = "zstd",
  compression_level = 3,
  statistics = TRUE,
  row_group_size = NULL,
  data_page_size = NULL,
  partition_by = NULL,
  partition_chunk_size_bytes = 4294967296
) {
  if (!inherits(.data, "RPolarsDataFrame")) {
    cli_abort("{.fn write_parquet_polars} can only be used on a DataFrame.")
  }

  rlang::arg_match0(
    compression,
    values = c("lz4", "uncompressed", "snappy", "gzip", "lzo", "brotli", "zstd")
  )
  rlang::check_dots_empty()

  .data$write_parquet(
    file,
    compression = compression,
    compression_level = compression_level,
    statistics = statistics,
    row_group_size = row_group_size,
    data_page_size = data_page_size,
    partition_by = partition_by,
    partition_chunk_size_bytes = partition_chunk_size_bytes
  )
}

#' Export data to NDJSON file(s)
#'
#' @inheritParams write_csv_polars
#'
#' @inherit write_csv_polars return
#' @export
#'
#' @examplesIf requireNamespace("jsonlite")
#' dest <- tempfile(fileext = ".ndjson")
#' mtcars |>
#'   as_polars_df() |>
#'   write_ndjson_polars(dest)
#'
#' jsonlite::stream_in(file(dest), verbose = FALSE)
write_ndjson_polars <- function(.data, file) {
  if (!inherits(.data, "RPolarsDataFrame")) {
    cli_abort("{.fn write_ndjson_polars} can only be used on a DataFrame.")
  }
  .data$write_ndjson(file = file)
}

#' Export data to JSON file(s)
#'
#' @inheritParams write_csv_polars
#' @param pretty Pretty serialize JSON.
#' @param row_oriented Write to row-oriented JSON. This is slower, but more
#' common.
#'
#' @inherit write_csv_polars return
#' @export
#'
#' @examplesIf requireNamespace("jsonlite")
#' dest <- tempfile(fileext = ".json")
#' mtcars |>
#'   as_polars_df() |>
#'   write_json_polars(dest)
#'
#' jsonlite::fromJSON(dest)
write_json_polars <- function(
  .data,
  file,
  ...,
  pretty = FALSE,
  row_oriented = FALSE
) {
  if (!inherits(.data, "RPolarsDataFrame")) {
    cli_abort("{.fn write_json_polars} can only be used on a DataFrame.")
  }

  rlang::check_dots_empty()

  .data$write_json(
    file = file,
    pretty = pretty,
    row_oriented = row_oriented
  )
}

#' Export data to IPC file(s)
#'
#' @inheritParams write_csv_polars
#' @param compression `NULL` or a character of the compression method,
#' `"uncompressed"` or "lz4" or "zstd". `NULL` is equivalent to `"uncompressed"`.
#' Choose "zstd" for good compression performance. Choose "lz4"
#' for fast compression/decompression.
#' @param future Setting this to `TRUE` will write Polars' internal data
#' structures that might not be available by other Arrow implementations.
#'
#' @inherit write_csv_polars return
#' @export
write_ipc_polars <- function(
  .data,
  file,
  compression = "uncompressed",
  ...,
  future = FALSE
) {
  if (!inherits(.data, "RPolarsDataFrame")) {
    cli_abort("{.fn write_ipc_polars} can only be used on a DataFrame.")
  }

  rlang::arg_match0(compression, values = c("uncompressed", "zstd", "lz4"))
  rlang::check_dots_empty()

  .data$write_ipc(
    file,
    compression = compression,
    future = future
  )
}
