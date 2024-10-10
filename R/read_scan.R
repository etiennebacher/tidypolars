#' Import data from Parquet file(s)
#'
#' @description
#' `read_parquet_polars()` imports the data as a Polars DataFrame.
#'
#' `scan_parquet_polars()` imports the data as a Polars LazyFrame.
#'
#' @inherit polars::pl_scan_parquet params details
#'
#' @rdname from_parquet
#' @name from_parquet
#' @export
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

  rlang::arg_match0(parallel, values = c("auto", "columns", "row_groups", "none"))
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
#' @inherit polars::pl_scan_csv params details
#'
#' @rdname from_csv
#' @name from_csv
#' @export
read_csv_polars <- function(
    source,
    ...,
    has_header = TRUE,
    separator = ",",
    comment_prefix = NULL,
    quote_char = "\"",
    skip_rows = 0,
    dtypes = NULL,
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
    reuse_downloaded = TRUE
) {

  rlang::arg_match0(encoding, values = c("utf8", "utf8-lossy"))
  rlang::check_dots_empty()

  scan_csv_polars(
    source = source,
    has_header = has_header,
    separator = separator,
    comment_prefix = comment_prefix,
    quote_char = quote_char,
    skip_rows = skip_rows,
    dtypes = dtypes,
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
    reuse_downloaded = reuse_downloaded
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
    dtypes = NULL,
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
    reuse_downloaded = TRUE
) {

  rlang::arg_match0(encoding, values = c("utf8", "utf8-lossy"))
  rlang::check_dots_empty()

  pl$scan_csv(
    source = source,
    has_header = has_header,
    separator = separator,
    comment_prefix = comment_prefix,
    quote_char = quote_char,
    skip_rows = skip_rows,
    dtypes = dtypes,
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
    reuse_downloaded = reuse_downloaded
  )
}


#' Import data from NDJSON file(s)
#'
#' @description
#' `read_ndjson_polars()` imports the data as a Polars DataFrame.
#'
#' `scan_ndjson_polars()` imports the data as a Polars LazyFrame.
#'
#' @inherit polars::pl_scan_ndjson params details
#'
#' @rdname from_ndjson
#' @name from_ndjson
#' @export
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
    reuse_downloaded = TRUE,
    ignore_errors = FALSE
) {

  rlang::check_dots_empty()

  scan_ndjson_polars(
    source = source,
    infer_schema_length = infer_schema_length,
    batch_size = batch_size,
    n_rows = n_rows,
    low_memory = low_memory,
    rechunk = rechunk,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    reuse_downloaded = reuse_downloaded,
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
    reuse_downloaded = TRUE,
    ignore_errors = FALSE
) {

  rlang::check_dots_empty()

  pl$scan_ndjson(
    source = source,
    infer_schema_length = infer_schema_length,
    batch_size = batch_size,
    n_rows = n_rows,
    low_memory = low_memory,
    rechunk = rechunk,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    reuse_downloaded = reuse_downloaded,
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
#' @inherit polars::pl_scan_ipc params details
#'
#' @rdname from_ipc
#' @name from_ipc
#' @export
read_ipc_polars <- function(
    source,
    ...,
    n_rows = NULL,
    memory_map = TRUE,
    row_index_name = NULL,
    row_index_offset = 0L,
    rechunk = FALSE,
    cache = TRUE,
    include_file_paths = NULL
) {

  rlang::check_dots_empty()

  scan_ipc_polars(
    source = source,
    n_rows = n_rows,
    memory_map = memory_map,
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
    memory_map = TRUE,
    row_index_name = NULL,
    row_index_offset = 0L,
    rechunk = FALSE,
    cache = TRUE,
    include_file_paths = NULL
) {

  rlang::check_dots_empty()

  pl$scan_ipc(
    source = source,
    n_rows = n_rows,
    memory_map = memory_map,
    row_index_name = row_index_name,
    row_index_offset = row_index_offset,
    rechunk = rechunk,
    cache = cache,
    include_file_paths = include_file_paths
  )
}
