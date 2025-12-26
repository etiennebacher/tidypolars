#' Split a string column into rows
#'
#' @description
#'
#' Each of these functions takes a string and splits it into multiple rows:
#'
#' - `separate_longer_delim_polars()` splits by delimiter.
#' It is the `polars` equivalent of `tidyr::separate_longer_delim()`.
#'
#' - `separate_longer_position_polars()` splits by fixed width.
#' It is the `polars` equivalent of `tidyr::separate_longer_position()`.
#'
#' @param data A Polars DataFrame or LazyFrame.
#' @param cols <[`tidy-select`][tidyr_tidy_select]> Column(s) to separate.
#' @param delim The delimiter string to split on. For `separate_longer_delim_polars()` only.
#' @param width The width of each piece. For `separate_longer_position_polars()` only.
#' @param ... These dots are for future extensions and must be empty.
#' @param keep_empty If `TRUE`, empty strings are kept in the output.
#'   If `FALSE` (the default), empty strings are dropped.
#'   `NA` values are always kept.
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
#' library(tidypolars)
#'
#' # separate_longer_delim_polars: split by delimiter
#' df <- pl$DataFrame(
#'   id = 1:3,
#'   x = c("a,b,c", "d,e", "f")
#' )
#' separate_longer_delim_polars(df, x, delim = ",")
#'
#' # Multiple columns with broadcasting, the same as `tidyr` behavior
#' df2 <- pl$DataFrame(
#'   id = 1:2,
#'   x = c("a,b", "c,d"),
#'   y = c("1,2", "3,4")
#' )
#' separate_longer_delim_polars(df2, c(x, y), delim = ",")
#'
#' # Multiple columns with broadcasting
#' df3 <- pl$DataFrame(
#'   id = 1:5,
#'   x = c("a,b", NA, "", "c", ""),
#'   y = c("1", "2,3", "4,5", NA, "")
#' )
#' separate_longer_delim_polars(df3, c(x, y), delim = ",")
#'
#' # separate_longer_position_polars: split by fixed width
#' df4 <- pl$DataFrame(
#'   id = 1:3,
#'   x = c("abcd", "efg", "hi")
#' )
#' separate_longer_position_polars(df4, x, width = 2)
#'
#' # keep_empty example: control whether empty strings are preserved
#' df5 <- pl$DataFrame(
#'   id = 1:4,
#'   x = c("ab", "", "ef", NA)
#' )
#' separate_longer_position_polars(df5, x, width = 2)
#' separate_longer_position_polars(df5, x, width = 2, keep_empty = TRUE)
#'
#' # Multiple columns with broadcasting
#' df6 <- pl$DataFrame(
#'   id = 1:3,
#'   x = c("a", "bc", "def"),
#'   y = c("12", "345", "67")
#' )
#' # Shorter strings are recycled to match the longest in each row
#' separate_longer_position_polars(df6, c(x, y), width = 2)
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

  # Capture the column expression (tidyr coerces to string before splitting)
  col_names <- tidyselect_named_arg(data, rlang::enquo(cols))

  # Empty delimiter: tidyr returns all NAs (with warning in base R)
  if (delim == "") {
    null_exprs <- lapply(col_names, function(nm) {
      pl$lit(NULL)$cast(pl$String)$alias(nm)
    })
    out <- data$with_columns(!!!null_exprs)
    return(add_tidypolars_class(out))
  }

  # Cast to string and split each column by delimiter, converting to list
  out <- data$with_columns(
    pl$col(!!!col_names)$cast(pl$String)$str$split(delim)
  )

  # Handle multi-column broadcasting and validation
  if (length(col_names) > 1) {
    # Convert lists containing only empty strings [""] to empty lists []
    # This matches `tidyr` behavior where "" split by "," gives character(0)
    # Only do this for multi-column case to enable proper broadcasting
    empty_list_exprs <- lapply(col_names, function(nm) {
      col <- pl$col(nm)
      # Check if list has length 1 and that element is ""
      is_empty_string <- col$list$len() == 1 & col$list$first() == ""
      # If so, replace with empty list, otherwise keep original
      pl$when(is_empty_string)$then(
        pl$lit(list(character(0)))
      )$otherwise(col)$alias(nm)
    })
    out <- out$with_columns(!!!empty_list_exprs)

    out <- handle_multi_column_explode(out, col_names)
  }

  # Explode all columns together
  add_tidypolars_class(out$explode(col_names))
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

  # Capture the column expression (tidyr coerces to string before splitting)
  col_names <- tidyselect_named_arg(data, rlang::enquo(cols))

  # Cast to string and use regex to extract groups of `width` characters
  # Pattern: .{1,width} matches 1 to width characters (greedy)
  pattern <- paste0(".{1,", width, "}")
  out <- data$with_columns(
    pl$col(!!!col_names)$cast(pl$String)$str$extract_all(pattern)
  )

  # Handle keep_empty
  if (!keep_empty) {
    cols <- pl$col(!!!col_names)
    condition <- cols$is_null() | cols$list$len() > 0
    out <- out$filter(pl$all_horizontal(condition))
  }

  # Handle multi-column broadcasting and validation
  if (length(col_names) > 1) {
    out <- handle_multi_column_explode(out, col_names)
  }

  # Explode all columns together
  add_tidypolars_class(out$explode(col_names))
}

#' Helper function to handle multi-column explode with broadcasting
#'
#' Handles broadcasting and validation for multi-column explode operations,
#' following `tidyr` behavior:
#' - Columns with length 0 (empty) or 1 are broadcast to match the row's max length
#' - Null values are repeated to match the max length
#' - Empty lists (from empty strings) become `[""]` when max_len is 0
#' - Error if two columns both have length >= 2 but different lengths
#'
#' @param data A Polars DataFrame with list columns to explode
#' @param col_names Character vector of column names to process
#'
#' @return A Polars DataFrame with columns broadcast to compatible lengths
#'   (ready for explode operation)
#'
#' @noRd
handle_multi_column_explode <- function(data, col_names) {
  # Create length columns for each list column
  len_col_names <- paste0(".len_", col_names)
  data <- data$with_columns(
    !!!lapply(seq_along(col_names), function(i) {
      pl$col(col_names[i])$list$len()$alias(len_col_names[i])
    })
  )

  # Calculate max length per row
  data <- data$with_columns(pl$max_horizontal(len_col_names)$alias(".max_len"))

  # Check for incompatible lengths (n to m where n, m >= 2 and n != m)
  incompatible_expr <- pl$any_horizontal(
    !!!lapply(len_col_names, function(len_col) {
      pl$col(len_col) > 1 & pl$col(len_col) != pl$col(".max_len")
    })
  )

  # Find first problematic row - filter, select, and collect in one chain
  first_problem <- data$filter(incompatible_expr)$select(len_col_names)$head(1L)
  if (inherits(first_problem, "polars_lazy_frame")) {
    first_problem <- first_problem$collect()
  }

  # Report error with size information if found
  if (first_problem$height > 0L) {
    lens <- sapply(len_col_names, function(nm) {
      as.data.frame(first_problem$select(nm))[[1]]
    })
    sizes_gt_1 <- unique(lens[lens > 1 & !is.na(lens)])
    rlang::abort(
      paste0(
        "Can't recycle input of size ",
        min(sizes_gt_1),
        " to size ",
        max(sizes_gt_1),
        "."
      )
    )
  }

  # Broadcast columns to match max_len using unified repeat logic
  repeat_exprs <- lapply(seq_along(col_names), function(i) {
    col <- pl$col(col_names[i])
    len <- pl$col(len_col_names[i])
    max_len <- pl$col(".max_len")

    pl$when(
      # Need broadcasting: len < 2 OR (len is null AND max_len > 0)
      len < 2 | (len$is_null() & max_len > 0)
    )$then(
      # For null/empty/single lists, repeat first value (or "" for empty)
      pl$when(col$is_null())$then(
        pl$lit(NULL)$cast(pl$String)
      )$when(len == 0)$then(
        pl$lit("")$cast(pl$String)
      )$otherwise(
        col$list$first()
      )$repeat_by(max_len$clip(1L))
    )$otherwise(col)$alias(col_names[i])
  })

  data$with_columns(!!!repeat_exprs)$drop(c(len_col_names, ".max_len"))
}
