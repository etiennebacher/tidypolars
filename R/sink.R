#' Stream output to a parquet file
#'
#' This function allows to stream a LazyFrame that is larger than RAM directly
#' to a `.parquet` file without collecting it in the R session, thus preventing
#' crashes because of too small memory.
#'
#' @param .data A Polars LazyFrame.
#' @param path Output file. Can also be a `partition_*()` function to export the
#' output to multiple files (see Details section below).
#' @param ... Ignored.
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
#'   used if `compression` is one of "gzip", "brotli", or "zstd". Higher
#'   compression means smaller files on disk.
#'
#' * "gzip" : min-level = 0, max-level = 10
#' * "brotli" : min-level = 0, max-level = 11
#' * "zstd" : min-level = 1, max-level = 22.
#'
#' @param statistics Whether to compute and write column statistics (default is
#'   `FALSE`). This requires more computations.
# TODO: need to clarify these 2 params. What do we mean by "chunks of the DataFrame".
# Having a "Details" section where we explain how sinking/streaming works might
# be useful.
#' @param row_group_size Size of the row groups in number of rows. If `NULL`
#'   (default), the chunks of the DataFrame are used. Writing in smaller chunks
#'   may reduce memory pressure and improve writing speeds.
#' @param data_page_size If `NULL` (default), the limit will be around 1MB.
#' @param maintain_order Whether maintain the order the data was processed
#'   (default is `TRUE`). Setting this to `FALSE` will be slightly faster.
#' @param type_coercion Coerce types such that operations succeed and run on
#'   minimal required memory (default is `TRUE`).
#' @param predicate_pushdown Applies filters as early as possible at scan level
#'   (default is `TRUE`).
#' @param projection_pushdown Select only the columns that are needed at the
#'   scan level (default is `TRUE`).
#' @param simplify_expression Various optimizations, such as constant folding
#'   and replacing expensive operations with faster alternatives (default is
#'   `TRUE`).
#' @param slice_pushdown Only load the required slice from the scan. Don't
#'   materialize sliced outputs level. Don't materialize sliced outputs (default
#'   is `TRUE`).
#' @param no_optimization Sets the following optimizations to `FALSE`:
#'   `predicate_pushdown`, `projection_pushdown`,  `slice_pushdown`,
#'   `simplify_expression`. Default is `FALSE`.
#' @param mkdir Recursively create all the directories in the path.
#'
#' @details
#'
#' ## Partitioned output
#'
#' It is possible to export a LazyFrame to multiple files, also called
#' *partitioned output*. A partition can be determined in several ways:
#'
#' - by key(s): split by the values of keys. The amount of files that can be
#'   written is not limited. However, when writing beyond a certain amount of
#'   files, the data for the remaining partitions is buffered before writing to
#'   the file.
#' - by maximum number of rows: if the number of rows in a file reaches the
#'   maximum number of rows, the file is closed and a new file is opened.
#' - by "sorted partition": this is a specialized version of partitioning by
#'   key. Whereas partitioning by key accepts data in any order, this scheme
#'   expects the input data to be pre-grouped or pre-sorted. This scheme suffers
#'   a lot less overhead, but may not be always applicable. Each new value of
#'   the key expressions starts a new partition, therefore repeating the same
#'   value multiple times may overwrite previous partitions.
#'
#' These partitioning schemes can be used with the functions `partition_by_key()`,
#' `partition_by_max_size()`, and `partition_parted()`. See Examples below.
#'
#' Writing a partitioned output usually requires setting `mkdir = TRUE` to
#' automatically create the required subfolders.
#'
#' @return The input LazyFrame.
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
#' write.csv(fake_data, file = file_csv, row.names = FALSE)
#'
#' # In a new R session, we could read this file as a LazyFrame, do some operations,
#' # and write it to a parquet file without ever collecting it in the R session:
#' scan_csv_polars(file_csv) |>
#'   filter(cyl %in% c(4, 6), mpg > 22) |>
#'   mutate(
#'     hp_gear_ratio = hp / gear
#'   ) |>
#'   sink_parquet(path = file_parquet)
#'
#'
#' #----------------------------------------------
#' # Write a LazyFrame to multiple files depending on various strategies.
#' my_lf <- as_polars_lf(mtcars)
#' tempdir_out <- tempdir()
#' out_path <- fs::path(tempdir_out, "out")
#'
#' # Split the LazyFrame by key(s) and write each split to a different file:
#' sink_parquet(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
#' fs::dir_tree(out_path)
#'
#' # Split the LazyFrame by max number of rows per file:
#' sink_parquet(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
#' fs::dir_tree(out_path) # mtcars has 32 rows so we have 7 output files
#'
#' # Split the LazyFrame by pre-sorted data:
#' sink_parquet(my_lf, partition_parted(out_path, max_size = 5), mkdir = TRUE)
#' fs::dir_tree(out_path) # mtcars has 32 rows so we have 7 output files
#' }
sink_parquet <- function(
  .data,
  path,
  ...,
  compression = "zstd",
  compression_level = 3,
  statistics = FALSE,
  row_group_size = NULL,
  data_page_size = NULL,
  maintain_order = TRUE,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  no_optimization = FALSE,
  mkdir = FALSE
) {
  check_dots_empty()

  if (!is_polars_lf(.data)) {
    cli_abort("{.fn sink_parquet} can only be used on a Polars LazyFrame.")
  }

  .data$sink_parquet(
    path = path,
    compression = compression,
    compression_level = compression_level,
    statistics = statistics,
    row_group_size = row_group_size,
    data_page_size = data_page_size,
    maintain_order = maintain_order,
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    no_optimization = no_optimization,
    mkdir = mkdir
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
#' @param quote_char Byte to use as quoting character.
#' @param batch_size Number of rows that will be processed per thread.
#' @param datetime_format,date_format,time_format A format string used to format
#' date and time values. See `?strptime()` for accepted values. If no format
#' specified, the default fractional-second precision is inferred from the
#' maximum time unit found in the `Datetime` cols (if any).
#' @param float_precision Number of decimal places to write, applied to both
#' `Float32` and `Float64` datatypes.
#' @param null_value A string representing null values (defaulting to the empty
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
#' @param quote `r lifecycle::badge("deprecated")` Deprecated, use `quote_char`
#' instead.
#' @param null_values `r lifecycle::badge("deprecated")` Deprecated, use
#' `null_value` instead.
#'
#' @inheritParams sink_parquet
#'
#' @inherit sink_parquet return
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
#' write.csv(fake_data, file = file_csv, row.names = FALSE)
#'
#' # In a new R session, we could read this file as a LazyFrame, do some operations,
#' # and write it to another CSV file without ever collecting it in the R session:
#' scan_csv_polars(file_csv) |>
#'   filter(cyl %in% c(4, 6), mpg > 22) |>
#'   mutate(
#'     hp_gear_ratio = hp / gear
#'   ) |>
#'   sink_csv(path = file_csv2)
#' }
sink_csv <- function(
  .data,
  path,
  ...,
  include_bom = FALSE,
  include_header = TRUE,
  separator = ",",
  line_terminator = "\n",
  quote_char = '"',
  batch_size = 1024,
  datetime_format = NULL,
  date_format = NULL,
  time_format = NULL,
  float_precision = NULL,
  null_value = "",
  quote_style = "necessary",
  maintain_order = TRUE,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  no_optimization = FALSE,
  mkdir = FALSE,
  quote,
  null_values
) {
  check_dots_empty()
  if (!is_polars_lf(.data)) {
    cli_abort("{.fn sink_csv} can only be used on a Polars LazyFrame.")
  }

  rlang::arg_match0(
    quote_style,
    values = c("necessary", "always", "non_numeric")
  )

  if (!missing(quote)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "sink_csv_polars(quote)",
      details = "Use `quote_char` instead."
    )
    quote_char <- quote
  }

  if (!missing(null_values)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "sink_csv_polars(null_values)",
      details = "Use `null_value` instead."
    )
    null_values <- null_values
  }

  .data$sink_csv(
    path = path,
    include_bom = include_bom,
    include_header = include_header,
    separator = separator,
    line_terminator = line_terminator,
    quote_char = quote_char,
    batch_size = batch_size,
    datetime_format = datetime_format,
    date_format = date_format,
    time_format = time_format,
    float_precision = float_precision,
    null_value = null_value,
    quote_style = quote_style,
    maintain_order = maintain_order,
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    no_optimization = no_optimization,
    mkdir = mkdir
  )
}

#' Stream output to an IPC file
#'
#' This function allows to stream a LazyFrame that is larger than RAM directly
#' to an IPC file without collecting it in the R session, thus preventing
#' crashes because of too small memory.
#'
#' @param path Output file.
#' @param compression `NULL` or a character of the compression method,
#' `"uncompressed"` or "lz4" or "zstd". `NULL` is equivalent to `"uncompressed"`.
#' Choose "zstd" for good compression performance. Choose "lz4"
#' for fast compression/decompression.
#'
#' @inheritParams sink_parquet
#' @inheritParams write_ipc_polars
#'
#' @inherit sink_parquet return
#' @export

sink_ipc <- function(
  .data,
  path,
  ...,
  compression = "zstd",
  compat_level = "newest",
  maintain_order = TRUE,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  no_optimization = FALSE,
  mkdir = FALSE
) {
  check_dots_empty()
  if (!is_polars_lf(.data)) {
    cli_abort("{.fn sink_ipc} can only be used on a Polars LazyFrame.")
  }

  rlang::arg_match0(compression, values = c("zstd", "lz4", "uncompressed"))

  .data$sink_ipc(
    path = path,
    compat_level = compat_level,
    compression = compression,
    maintain_order = maintain_order,
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    no_optimization = no_optimization,
    mkdir = mkdir
  )
}

#' Stream output to a NDJSON file
#'
#' This writes the output of a query directly to a NDJSON file without collecting
#' it in the R session first. This is useful if the output of the query is still
#' larger than RAM as it would crash the R session if it was collected into R.
#'
#' @param path Output file.
#'
#' @inheritParams sink_parquet
#'
#' @inherit sink_parquet return
#' @export

sink_ndjson <- function(
  .data,
  path,
  ...,
  maintain_order = TRUE,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  no_optimization = FALSE,
  mkdir = FALSE
) {
  check_dots_empty()
  if (!is_polars_lf(.data)) {
    cli_abort("{.fn sink_ndjson} can only be used on a Polars LazyFrame.")
  }

  .data$sink_ndjson(
    path = path,
    maintain_order = maintain_order,
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    no_optimization = no_optimization,
    mkdir = mkdir
  )
}


#' @export
partition_by_key <- function(
  base_path,
  ...,
  by,
  include_key = TRUE,
  per_partition_sort_by = NULL
) {
  check_dots_empty()
  pl$PartitionByKey(
    base_path = base_path,
    by = by,
    include_key = TRUE,
    per_partition_sort_by = NULL
  )
}

#' @export
partition_by_max_size <- function(
  base_path,
  ...,
  max_size,
  per_partition_sort_by = NULL
) {
  check_dots_empty()
  pl$PartitionMaxSize(
    base_path = base_path,
    max_size = max_size,
    per_partition_sort_by = NULL
  )
}
