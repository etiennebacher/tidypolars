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

