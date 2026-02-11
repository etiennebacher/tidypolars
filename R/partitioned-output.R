#' Helper functions to export data as a partitioned output
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Partitioning schemes are used to write multiple files with `sink_*()` and
#' `write_*_polars()` functions.
#'
#' - `partition_by()`: Configuration for writing to multiple output files.
#'   Supports partitioning by key, file size limits, or both.
#'
#' The following functions are deprecated and will be removed in a future release:
#'
#' - `r lifecycle::badge("deprecated")` `partition_by_key()`: use
#'   `partition_by(key = ...)` instead.
#' - `r lifecycle::badge("deprecated")` `partition_by_max_size()`: use
#'   `partition_by(max_rows_per_file = ...)` instead.
#'
#' @inheritParams rlang::args_dots_empty
#' @param base_path The base path for the output files. Use the `mkdir` option
#' of the `sink_*` or `write_*_polars()` functions to ensure directories in the
#' path are created.
#' @param key Something can be coerced to a list of Polars expressions. Used to
#' partition by.
#' @param include_key A bool indicating whether to include the key columns in
#' the output files. Can only be used if `key` is specified, otherwise should
#' be `NULL`.
#' @param max_rows_per_file An integer-ish value indicating the maximum size in
#' rows of each of the generated files.
#' @param approximate_bytes_per_file An integer-ish value indicating approximate
#' number of bytes to write to each file, or `NULL`. This is measured as the
#' estimated size of the DataFrame in memory. Defaults to approximately 4GB when
#' `key` is specified without `max_rows_per_file`, otherwise unlimited.
#' @param by `r lifecycle::badge("deprecated")` Something can be coerced to a
#' list of Polars expressions. Used to partition by. Use the `key` property of
#' `partition_by()` instead.
#' @param per_partition_sort_by `r lifecycle::badge("deprecated")` Something
#' that can be coerced to a list of Polars expressions, or `NULL` (default).
#' Used to sort over within each partition. Use the `per_partition_sort_by`
#' property of `partition_by()` instead.
#' @param max_size `r lifecycle::badge("deprecated")` An integer-ish value
#' indicating the maximum size in rows of each of the generated files. Use the
#' `max_rows_per_file` property of `partition_by()` instead.
#'
#' @name partitioned_output
#' @export
partition_by <- function(
  base_path,
  ...,
  key = NULL,
  include_key = NULL,
  max_rows_per_file = NULL,
  approximate_bytes_per_file = NULL
) {
  check_dots_empty()
  pl$PartitionBy(
    base_path = base_path,
    key = key,
    include_key = include_key,
    max_rows_per_file = max_rows_per_file,
    approximate_bytes_per_file = approximate_bytes_per_file
  )
}

#' @name partitioned_output
#' @export
partition_by_key <- function(
  base_path,
  ...,
  by,
  include_key = TRUE
) {
  check_dots_empty()

  lifecycle::deprecate_warn(
    when = "0.16.0",
    what = "partition_by_key()",
    details = "Please use `partition_by(key = )` instead.",
    always = TRUE,
  )

  suppressWarnings(
    pl$PartitionByKey(
      base_path = base_path,
      by = by,
      include_key = include_key
    )
  )
}

#' @rdname partitioned_output
#' @export
partition_by_max_size <- function(
  base_path,
  ...,
  max_size
) {
  check_dots_empty()

  lifecycle::deprecate_warn(
    when = "0.16.0",
    what = "partition_by_max_size()",
    details = "Please use `partition_by(max_rows_per_file = )` instead.",
    always = TRUE,
  )
  suppressWarnings(
    pl$PartitionMaxSize(
      base_path = base_path,
      max_size = max_size
    )
  )
}
