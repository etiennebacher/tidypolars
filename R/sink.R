#' Stream output to a parquet file
#'
#' This function allows to stream a LazyFrame that is larger than RAM directly
#' to a `.parquet` file without collecting it in the R session, thus preventing
#' crashes because of too small memory.
#'
#' @param .data A Polars LazyFrame.
#' @param path Output file (must be a `.parquet` file).
#' @param compression The compression method. One of :
#'
#' * "uncompressed"
#' * "zstd" (default): good compression performance
#' * "lz4": fast compression / decompression
#' * "snappy": more backwards compatibility guarantees when you deal with older
#'   parquet readers.
#' * "gzip", "lzo", "brotli"
#'
#' @param compression_level The level of compression to use (default is 3). Only
#' used if `compression` is one of "gzip", "brotli", or "zstd". Higher
#' compression means smaller files on disk.
#'
#' * "gzip" : min-level = 0, max-level = 10
#' * "brotli" : min-level = 0, max-level = 11
#' * "zstd" : min-level = 1, max-level = 22.
#'
#' @param statistics Whether to compute and write column statistics (default is
#' `FALSE`). This requires more computations.

# TODO: need to clarify these 2 params. What do we mean by "chunks of the DataFrame".
# Having a "Details" section where we explain how sinking/streaming works might
# be useful.
#' @param row_group_size Size of the row groups in number of rows. If `NULL`
#' (default), the chunks of the DataFrame are used. Writing in smaller chunks
#' may reduce memory pressure and improve writing speeds.
#' @param data_pagesize_limit If `NULL` (default), the limit will be around 1MB.

#' @param maintain_order Whether maintain the order the data was processed
#' (default is `TRUE`). Setting this to `FALSE` will be slightly faster.
#' @param type_coercion Coerce types such that operations succeed and run on
#' minimal required memory (default is `TRUE`).
#' @param predicate_pushdown Applies filters as early as possible at scan level
#' (default is `TRUE`).
#' @param projection_pushdown Select only the columns that are needed at the scan
#' level (default is `TRUE`).
#' @param simplify_expression Various optimizations, such as constant folding
#' and replacing expensive operations with faster alternatives (default is
#' `TRUE`).
#' @param slice_pushdown Only load the required slice from the scan. Don't
#' materialize sliced outputs level. Don't materialize sliced outputs (default
#' is `TRUE`).
#' @param no_optimization Sets the following optimizations to `FALSE`:
#' `predicate_pushdown`, `projection_pushdown`,  `slice_pushdown`,
#' `simplify_expression`. Default is `FALSE`.
#' @param inherit_optimization Use existing optimization settings regardless of
#' the settings specified in this function call. Default is `FALSE`.
#'
#' @return Writes a `.parquet` file with the content of the LazyFrame.
#' @export
#'
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' \dontrun{
#' # This is an example workflow where sink_parquet() is not very useful because
#' # the data would fit in memory. It simply is an example of using it at the
#' # end of a piped workflow.
#'
#' # Create files for the CSV input and the Parquet output:
#' file_csv <- tempfile(fileext = ".csv")
#' file_parquet <- tempfile(fileext = ".parquet")
#'
#' # Write some data in a CSV file
#' fake_data <- do.call("rbind", rep(list(mtcars), 1000))
#' write.csv(fake_data, file = file_csv)
#'
#' # In a new R session, we could read this file as a LazyFrame, do some operations,
#' # and write it to a parquet file without ever collecting it in the R session:
#' polars::pl$scan_csv(file_csv) |>
#'   filter(cyl %in% c(4, 6), mpg > 22) |>
#'   mutate(
#'     hp_gear_ratio = hp / gear
#'   ) |>
#'   sink_parquet(path = file_parquet)
#'
#' }

sink_parquet <- function(
    .data,
    path,
    compression = "zstd",
    compression_level = 3,
    statistics = FALSE,
    row_group_size = NULL,
    data_pagesize_limit = NULL,
    maintain_order = TRUE,
    type_coercion = TRUE,
    predicate_pushdown = TRUE,
    projection_pushdown = TRUE,
    simplify_expression = TRUE,
    slice_pushdown = TRUE,
    no_optimization = FALSE,
    inherit_optimization = FALSE
  ) {

  if (!inherits(.data, "RPolarsLazyFrame")) {
    rlang::abort("`sink_parquet()` can only be used on a LazyFrame.")
  }

  .data$sink_parquet(
    path = path,
    compression = compression,
    compression_level = compression_level,
    statistics = statistics,
    row_group_size = row_group_size,
    data_pagesize_limit = data_pagesize_limit,
    maintain_order = maintain_order,
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    no_optimization = no_optimization,
    inherit_optimization = inherit_optimization
  )

}

#' Stream output to a CSV file
#'
#' This function allows to stream a LazyFrame that is larger than RAM directly
#' to a `.csv` file without collecting it in the R session, thus preventing
#' crashes because of too small memory.
#'
#' @param .data A Polars LazyFrame.
#' @param path Output file (must be a `.csv` file).
#' @param include_bom Whether to include UTF-8 BOM (byte order mark) in the CSV
#' output.
#' @param include_header Whether to include header in the CSV output.
#' @param separator Separate CSV fields with this symbol.
#' @param line_terminator String used to end each row.
#' @param quote Byte to use as quoting character.
#' @param batch_size Number of rows that will be processed per thread.
#' @param datetime_format,date_format,time_format A format string used to format
#' date and time values. See `?strptime()` for accepted values. If no format
#' specified, the default fractional-second precision is inferred from the
#' maximum time unit found in the `Datetime` cols (if any).
#' @param float_precision Number of decimal places to write, applied to both
#' `Float32` and `Float64` datatypes.
#' @param null_values A string representing null values (defaulting to the empty
#' string).
#' @param quote_style Determines the quoting strategy used:
#' * `"necessary"` (default): This puts quotes around fields only when necessary.
#'   They are necessary when fields contain a quote, delimiter or record terminator.
#'   Quotes are also necessary when writing an empty record (which is
#'   indistinguishable from a record with one empty field).
#' * `"always"`: This puts quotes around every field.
#' * `"non_numeric"`: This puts quotes around all fields that are non-numeric.
#'   Namely, when writing a field that does not parse as a valid float or integer,
#'   then quotes will be used even if they aren't strictly necessary.
#'
#' @inheritParams sink_parquet
#'
#' @return Writes a `.csv` file with the content of the LazyFrame.
#' @export
#'
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' \dontrun{
#' # This is an example workflow where sink_csv() is not very useful because
#' # the data would fit in memory. It simply is an example of using it at the
#' # end of a piped workflow.
#'
#' # Create files for the CSV input and output:
#' file_csv <- tempfile(fileext = ".csv")
#' file_csv2 <- tempfile(fileext = ".csv")
#'
#' # Write some data in a CSV file
#' fake_data <- do.call("rbind", rep(list(mtcars), 1000))
#' write.csv(fake_data, file = file_csv)
#'
#' # In a new R session, we could read this file as a LazyFrame, do some operations,
#' # and write it to another CSV file without ever collecting it in the R session:
#' polars::pl$scan_csv(file_csv) |>
#'   filter(cyl %in% c(4, 6), mpg > 22) |>
#'   mutate(
#'     hp_gear_ratio = hp / gear
#'   ) |>
#'   sink_csv(path = file_csv2)
#'
#' }

sink_csv <- function(
    .data,
    path,
    include_bom = FALSE,
    include_header = TRUE,
    separator = ",",
    line_terminator = "\n",
    quote = '"',
    batch_size = 1024,
    datetime_format = NULL,
    date_format = NULL,
    time_format = NULL,
    float_precision = NULL,
    null_values = "",
    quote_style = "necessary",
    maintain_order = TRUE,
    type_coercion = TRUE,
    predicate_pushdown = TRUE,
    projection_pushdown = TRUE,
    simplify_expression = TRUE,
    slice_pushdown = TRUE,
    no_optimization = FALSE,
    inherit_optimization = FALSE
) {

  if (!inherits(.data, "RPolarsLazyFrame")) {
    rlang::abort("`sink_csv()` can only be used on a LazyFrame.")
  }

  rlang::arg_match0(quote_style, values = c("necessary", "always", "non_numeric"))

  .data$sink_csv(
    path = path,
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
    quote_style = quote_style,
    maintain_order = maintain_order,
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    no_optimization = no_optimization,
    inherit_optimization = inherit_optimization
  )

}

