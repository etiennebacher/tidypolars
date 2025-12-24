#' Split a string column into rows
#'
#' @description
#'
#' Each of these functions takes a string and splits it into multiple rows:
#'
#' - `separate_longer_delim_polars()` splits by delimiter.
#' It is the polars equivalent of `tidyr::separate_longer_delim()`.
#'
#' - `separate_longer_position_polars()` splits by fixed widths.
#' It is the polars equivalent of `tidyr::separate_longer_position()`.
#'
#' @param data A Polars DataFrame or LazyFrame.
#' @param cols <[`tidy-select`][tidyr_tidy_select]> Column(s) to separate.
#' @param delim The delimiter to split on. For `separate_longer_delim_polars()`
#'   only.
#' @param width The width of each piece. For `separate_longer_position_polars()`
#'   only.
#' @param ... These dots are for future extensions and must be empty.
#' @param keep_empty If `TRUE`, empty strings are kept in the output.
#'   If `FALSE` (the default), empty strings are dropped.
#'   For `separate_longer_delim_polars()`, empty strings are always kept.
#'
#' @return A Polars DataFrame or LazyFrame with the specified column(s) split
#'   into rows.
#'
#' @seealso [tidyr::separate_longer_delim()], [tidyr::separate_longer_position()]
#'
#' @name separate_longer
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' library(polars)
#'
#' # separate_longer_delim_polars: split by delimiter
#' df <- pl$DataFrame(
#'   id = 1:3,
#'   x = c("a,b,c", "d,e", "f")
#' )
#' df
#'
#' separate_longer_delim_polars(df, x, delim = ",")
#'
#' # Multiple columns
#' df2 <- pl$DataFrame(
#'   id = 1:2,
#'   x = c("a,b", "c,d"),
#'   y = c("1,2", "3,4")
#' )
#' separate_longer_delim_polars(df2, c(x, y), delim = ",")
#'
#' # separate_longer_position_polars: split by fixed width
#' df3 <- pl$DataFrame(
#'   id = 1:3,
#'   x = c("abcd", "efgh", "ij")
#' )
#' separate_longer_position_polars(df3, x, width = 2)
#'
#' # keep_empty example
#' df4 <- pl$DataFrame(
#'   id = 1:2,
#'   x = c("ab", "cdef")
#' )
#' # By default, short strings are kept (no empty pieces created)
#' separate_longer_position_polars(df4, x, width = 2)
separate_longer_delim_polars <- function(
  data,
  cols,
  delim,
  ...
) {
  check_polars_data(data)
  rlang::check_dots_empty()
  rlang::check_required(cols)
  check_string(delim)

  # Capture the column expression
  col_names <- tidyselect_named_arg(data, rlang::enquo(cols))

  # Check that all selected columns are string type
  schema <- suppressWarnings(data$collect_schema())
  non_string_cols <- vapply(
    col_names,
    function(col_nm) !inherits(schema[[col_nm]], "polars_dtype_string"),
    logical(1)
  )
  if (any(non_string_cols)) {
    return(add_tidypolars_class(data))
  }

  # Split each column by delimiter and convert to list
  split_exprs <- lapply(col_names, function(col_nm) {
    pl$col(col_nm)$str$split(delim)$alias(col_nm)
  })

  out <- data$with_columns(!!!split_exprs)

  # Explode all columns together

  out <- out$explode(col_names)

  add_tidypolars_class(out)
}


#' @rdname separate_longer
#' @export
separate_longer_position_polars <- function(
  data,
  cols,
  width,
  ...,
  keep_empty = FALSE
) {
  check_polars_data(data)
  rlang::check_dots_empty()
  rlang::check_required(cols)
  check_number_whole(width, min = 1)
  check_bool(keep_empty)

  # Capture the column expression
  col_names <- tidyselect_named_arg(data, rlang::enquo(cols))

  # Check that all selected columns are string type
  schema <- suppressWarnings(data$collect_schema())
  non_string_cols <- vapply(
    col_names,
    function(col_nm) !inherits(schema[[col_nm]], "polars_dtype_string"),
    logical(1)
  )
  if (any(non_string_cols)) {
    return(add_tidypolars_class(data))
  }

  # Use regex to extract groups of `width` characters
  # Pattern: .{1,width} matches 1 to width characters (greedy)
  pattern <- paste0(".{1,", width, "}")

  # Extract all matches as list and convert to list
  split_exprs <- lapply(col_names, function(col_nm) {
    pl$col(col_nm)$str$extract_all(pattern)$alias(col_nm)
  })

  out <- data$with_columns(!!!split_exprs)

  # Handle keep_empty
  if (!keep_empty) {
    # Filter out empty lists (from empty strings) but keep NA values
    filter_exprs <- lapply(col_names, function(col_nm) {
      pl$col(col_nm)$is_null()$or(
        pl$col(col_nm)$list$len()$gt(0L)
      )
    })
    # Combine with AND
    combined_filter <- Reduce(`&`, filter_exprs)
    out <- out$filter(combined_filter)
  }

  # Explode all columns together
  out <- out$explode(col_names)

  add_tidypolars_class(out)
}
