#' Import data from Parquet file(s)
#'
#' @description
#' `read_parquet_polars()` imports the data as a Polars DataFrame.
#'
#' `scan_parquet_polars()` imports the data as a Polars LazyFrame.
#'
#' @inherit polars::pl__scan_parquet params details
#'
#' @rdname from_parquet
#' @name from_parquet
#' @return The scan function returns a LazyFrame, the read function returns a DataFrame.
#' @export
#'
#' @examplesIf require("dplyr", quietly = TRUE)
#' ### Read or scan a single Parquet file ------------------------
#'
#' # Setup: create a Parquet file
#' dest <- tempfile(fileext = ".parquet")
#' dat <- as_polars_df(mtcars)
#' write_parquet_polars(dat, dest)
#'
#' # Import this file as a DataFrame for eager evaluation
#' read_parquet_polars(dest) |>
#'   arrange(mpg)
#'
#' # Import this file as a LazyFrame for lazy evaluation
#' scan_parquet_polars(dest) |>
#'   arrange(mpg) |>
#'   compute()
#'
#'
#' ### Read or scan several all Parquet files in a folder ------------------------
#'
#' # Setup: create a folder "output" that contains two Parquet files
#' dest_folder <- file.path(tempdir(), "output")
#' dir.create(dest_folder, showWarnings = FALSE)
#' dest1 <- file.path(dest_folder, "output_1.parquet")
#' dest2 <- file.path(dest_folder, "output_2.parquet")
#'
#' write_parquet_polars(as_polars_df(mtcars[1:16, ]), dest1)
#' write_parquet_polars(as_polars_df(mtcars[17:32, ]), dest2)
#' list.files(dest_folder)
#'
#' # Import all files as a LazyFrame
#' scan_parquet_polars(dest_folder) |>
#'   arrange(mpg) |>
#'   compute()
#'
#' # Include the file path to know where each row comes from
#' scan_parquet_polars(dest_folder, include_file_paths = "file_path") |>
#'   arrange(mpg) |>
#'   compute()
#'
#'
#' ### Read or scan all Parquet files that match a glob pattern ------------------------
#'
#' # Setup: create a folder "output" that contains three Parquet files,
#' # two of which follow the pattern "output_XXX.parquet"
#' dest_folder <- file.path(tempdir(), "output_glob")
#' dir.create(dest_folder, showWarnings = FALSE)
#' dest1 <- file.path(dest_folder, "output_1.parquet")
#' dest2 <- file.path(dest_folder, "output_2.parquet")
#' dest3 <- file.path(dest_folder, "other_output.parquet")
#'
#' write_parquet_polars(as_polars_df(mtcars[1:16, ]), dest1)
#' write_parquet_polars(as_polars_df(mtcars[17:32, ]), dest2)
#' write_parquet_polars(as_polars_df(iris), dest3)
#' list.files(dest_folder)
#'
#' # Import only the files whose name match "output_XXX.parquet" as a LazyFrame
#' scan_parquet_polars(paste0(dest_folder, "/output_*.parquet")) |>
#'   arrange(mpg) |>
#'   compute()
read_parquet_polars <- function(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  parallel = "auto",
  hive_partitioning = NULL,
  hive_schema = NULL,
  try_parse_hive_dates = TRUE,
  glob = TRUE,
  rechunk = TRUE,
  low_memory = FALSE,
  storage_options = NULL,
  use_statistics = TRUE,
  cache = TRUE,
  include_file_paths = NULL
) {
  rlang::arg_match0(
    parallel,
    values = c("auto", "columns", "row_groups", "prefiltered", "none")
  )
  rlang::check_dots_empty()

  scan_parquet_polars(
    source = source,
    n_rows = n_rows,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    parallel = parallel,
    hive_partitioning = hive_partitioning,
    hive_schema = hive_schema,
    try_parse_hive_dates = try_parse_hive_dates,
    glob = glob,
    rechunk = rechunk,
    low_memory = low_memory,
    storage_options = storage_options,
    use_statistics = use_statistics,
    cache = cache,
    include_file_paths = include_file_paths
  ) |>
    compute()
}

#' @rdname from_parquet
#' @name from_parquet
#' @export
scan_parquet_polars <- function(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  parallel = "auto",
  hive_partitioning = NULL,
  hive_schema = NULL,
  try_parse_hive_dates = TRUE,
  glob = TRUE,
  rechunk = FALSE,
  low_memory = FALSE,
  storage_options = NULL,
  use_statistics = TRUE,
  cache = TRUE,
  include_file_paths = NULL
) {
  rlang::arg_match0(
    parallel,
    values = c("auto", "columns", "row_groups", "none")
  )
  rlang::check_dots_empty()

  pl$scan_parquet(
    source = source,
    n_rows = n_rows,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    parallel = parallel,
    hive_partitioning = hive_partitioning,
    hive_schema = hive_schema,
    try_parse_hive_dates = try_parse_hive_dates,
    glob = glob,
    rechunk = rechunk,
    low_memory = low_memory,
    storage_options = storage_options,
    use_statistics = use_statistics,
    cache = cache,
    include_file_paths = include_file_paths
  )
}

#' Import data from CSV file(s)
#'
#' @description
#' `read_csv_polars()` imports the data as a Polars DataFrame.
#'
#' `scan_csv_polars()` imports the data as a Polars LazyFrame.
#'
#' @inherit polars::pl__scan_csv params details
#' @param dtypes `r lifecycle::badge("deprecated")` Deprecated,
#' use `schema_overrides` instead.
#' @param reuse_downloaded `r lifecycle::badge("deprecated")`
#' Deprecated with no replacement.
#'
#' @rdname from_csv
#' @name from_csv
#' @export
#' @inherit from_parquet return
read_csv_polars <- function(
  source,
  ...,
  has_header = TRUE,
  separator = ",",
  comment_prefix = NULL,
  quote_char = "\"",
  skip_rows = 0,
  schema = NULL,
  schema_overrides = NULL,
  null_values = NULL,
  ignore_errors = FALSE,
  cache = FALSE,
  infer_schema_length = 100,
  n_rows = NULL,
  encoding = "utf8",
  low_memory = FALSE,
  rechunk = TRUE,
  skip_rows_after_header = 0,
  row_index_name = NULL,
  row_index_offset = 0,
  try_parse_dates = FALSE,
  eol_char = "\n",
  raise_if_empty = TRUE,
  truncate_ragged_lines = FALSE,
  include_file_paths = NULL,
  dtypes,
  reuse_downloaded
) {
  rlang::arg_match0(encoding, values = c("utf8", "utf8-lossy"))
  rlang::check_dots_empty()

  if (!missing(dtypes)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "read_csv_polars(dtypes)",
      details = "Use `schema_overrides` instead.",
    )
    schema_overrides <- dtypes
  }
  if (!missing(reuse_downloaded)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "read_csv_polars(reuse_downloaded)",
      details = "This argument has no replacement.",
    )
  }

  scan_csv_polars(
    source = source,
    has_header = has_header,
    separator = separator,
    comment_prefix = comment_prefix,
    quote_char = quote_char,
    skip_rows = skip_rows,
    schema = schema,
    schema_overrides = schema_overrides,
    null_values = null_values,
    ignore_errors = ignore_errors,
    cache = cache,
    infer_schema_length = infer_schema_length,
    n_rows = n_rows,
    encoding = encoding,
    low_memory = low_memory,
    rechunk = rechunk,
    skip_rows_after_header = skip_rows_after_header,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    try_parse_dates = try_parse_dates,
    eol_char = eol_char,
    raise_if_empty = raise_if_empty,
    truncate_ragged_lines = truncate_ragged_lines,
    include_file_paths = include_file_paths
  ) |>
    compute()
}

#' @rdname from_csv
#' @name from_csv
#' @export
scan_csv_polars <- function(
  source,
  ...,
  has_header = TRUE,
  separator = ",",
  comment_prefix = NULL,
  quote_char = "\"",
  skip_rows = 0,
  schema = NULL,
  schema_overrides = NULL,
  null_values = NULL,
  ignore_errors = FALSE,
  cache = FALSE,
  infer_schema_length = 100,
  n_rows = NULL,
  encoding = "utf8",
  low_memory = FALSE,
  rechunk = TRUE,
  skip_rows_after_header = 0,
  row_index_name = NULL,
  row_index_offset = 0,
  try_parse_dates = FALSE,
  eol_char = "\n",
  raise_if_empty = TRUE,
  truncate_ragged_lines = FALSE,
  include_file_paths = NULL,
  dtypes,
  reuse_downloaded
) {
  rlang::arg_match0(encoding, values = c("utf8", "utf8-lossy"))
  rlang::check_dots_empty()

  if (!missing(dtypes)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "scan_csv_polars(dtypes)",
      details = "Use `schema_overrides` instead.",
    )
    schema_overrides <- dtypes
  }
  if (!missing(reuse_downloaded)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "scan_csv_polars(reuse_downloaded)",
      details = "This argument has no replacement.",
    )
  }

  pl$scan_csv(
    source = source,
    has_header = has_header,
    separator = separator,
    comment_prefix = comment_prefix,
    quote_char = quote_char,
    skip_rows = skip_rows,
    schema = schema,
    schema_overrides = schema_overrides,
    null_values = null_values,
    ignore_errors = ignore_errors,
    cache = cache,
    infer_schema_length = infer_schema_length,
    n_rows = n_rows,
    encoding = encoding,
    low_memory = low_memory,
    rechunk = rechunk,
    skip_rows_after_header = skip_rows_after_header,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    try_parse_dates = try_parse_dates,
    eol_char = eol_char,
    raise_if_empty = raise_if_empty,
    truncate_ragged_lines = truncate_ragged_lines,
    include_file_paths = include_file_paths
  )
}

#' Import data from NDJSON file(s)
#'
#' @description
#' `read_ndjson_polars()` imports the data as a Polars DataFrame.
#'
#' `scan_ndjson_polars()` imports the data as a Polars LazyFrame.
#'
#' @inherit polars::pl__scan_ndjson params details
#' @param reuse_downloaded `r lifecycle::badge("deprecated")`
#' Deprecated with no replacement.
#'
#'
#' @rdname from_ndjson
#' @name from_ndjson
#' @export
#' @inherit from_parquet return
read_ndjson_polars <- function(
  source,
  ...,
  infer_schema_length = 100,
  batch_size = NULL,
  n_rows = NULL,
  low_memory = FALSE,
  rechunk = FALSE,
  row_index_name = NULL,
  row_index_offset = 0,
  ignore_errors = FALSE,
  reuse_downloaded
) {
  rlang::check_dots_empty()
  if (!missing(reuse_downloaded)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "read_ndjson_polars(reuse_downloaded)",
      details = "This argument has no replacement.",
    )
  }

  scan_ndjson_polars(
    source = source,
    infer_schema_length = infer_schema_length,
    batch_size = batch_size,
    n_rows = n_rows,
    low_memory = low_memory,
    rechunk = rechunk,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    ignore_errors = ignore_errors
  ) |>
    compute()
}

#' @rdname from_ndjson
#' @name from_ndjson
#' @export
scan_ndjson_polars <- function(
  source,
  ...,
  infer_schema_length = 100,
  batch_size = NULL,
  n_rows = NULL,
  low_memory = FALSE,
  rechunk = FALSE,
  row_index_name = NULL,
  row_index_offset = 0,
  ignore_errors = FALSE,
  reuse_downloaded
) {
  rlang::check_dots_empty()
  if (!missing(reuse_downloaded)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "scan_ndjson_polars(reuse_downloaded)",
      details = "This argument has no replacement.",
    )
  }

  pl$scan_ndjson(
    source = source,
    infer_schema_length = infer_schema_length,
    batch_size = batch_size,
    n_rows = n_rows,
    low_memory = low_memory,
    rechunk = rechunk,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    ignore_errors = ignore_errors
  )
}

#' Import data from IPC file(s)
#'
#' @description
#' `read_ipc_polars()` imports the data as a Polars DataFrame.
#'
#' `scan_ipc_polars()` imports the data as a Polars LazyFrame.
#'
#' @inherit polars::pl__scan_ipc params details
#' @param memory_map `r lifecycle::badge("deprecated")` Deprecated
#' with no replacement.
#'
#' @rdname from_ipc
#' @name from_ipc
#' @export
#' @inherit from_parquet return
read_ipc_polars <- function(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  rechunk = FALSE,
  cache = TRUE,
  include_file_paths = NULL,
  memory_map
) {
  rlang::check_dots_empty()
  if (!missing(memory_map)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "read_ipc_polars(memory_map)",
      details = "This argument has no replacement.",
    )
  }

  scan_ipc_polars(
    source = source,
    n_rows = n_rows,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    rechunk = rechunk,
    cache = cache,
    include_file_paths = include_file_paths
  ) |>
    compute()
}

#' @rdname from_ipc
#' @name from_ipc
#' @export
scan_ipc_polars <- function(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  rechunk = FALSE,
  cache = TRUE,
  include_file_paths = NULL,
  memory_map
) {
  rlang::check_dots_empty()
  if (!missing(memory_map)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "scan_ipc_polars(memory_map)",
      details = "This argument has no replacement.",
    )
  }

  pl$scan_ipc(
    source = source,
    n_rows = n_rows,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    rechunk = rechunk,
    cache = cache,
    include_file_paths = include_file_paths
  )
}
