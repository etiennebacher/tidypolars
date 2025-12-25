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

  # Capture the column expression and filter to only string columns
  col_names <- tidyselect_named_arg(data, rlang::enquo(cols)) |>
    intersect(names(data$select(pl$col(pl$String))))

  # If no string columns, return data unchanged (like tidyr)
  if (length(col_names) == 0) {
    return(add_tidypolars_class(data))
  }

  # Split each column by delimiter and convert to list
  out <- data$with_columns(
    do.call(pl$col, as.list(col_names))$str$split(delim)
  )

  # Handle multi-column broadcasting and validation
  if (length(col_names) > 1) {
    # Convert lists containing only empty strings [""] to empty lists []
    # This matches tidyr behavior where "" split by "," gives character(0)
    # Only do this for multi-column case to enable proper broadcasting
    empty_list_exprs <- lapply(col_names, function(nm) {
      col <- pl$col(nm)
      # Check if list has length 1 and that element is ""
      is_empty_string <- col$list$len()$eq(1)$and(col$list$first()$eq(""))
      # If so, replace with empty list, otherwise keep original
      pl$when(is_empty_string)$then(
        pl$lit(list(character(0)))$cast(pl$List(pl$String))
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

  # Capture the column expression and filter to only string columns
  col_names <- tidyselect_named_arg(data, rlang::enquo(cols)) |>
    intersect(names(data$select(pl$col(pl$String))))

  # If no string columns, return data unchanged (like tidyr)
  if (length(col_names) == 0) {
    return(add_tidypolars_class(data))
  }

  # Use regex to extract groups of `width` characters
  # Pattern: .{1,width} matches 1 to width characters (greedy)
  pattern <- paste0(".{1,", width, "}")
  out <- data$with_columns(
    do.call(pl$col, as.list(col_names))$str$extract_all(pattern)
  )

  # Handle keep_empty
  if (!keep_empty) {
    cols <- do.call(pl$col, as.list(col_names))
    condition <- cols$is_null()$or(cols$list$len()$gt(0))
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
#' Rules (following tidyr behavior):
#' 1. If all columns have the same length, explode normally
#' 2. If some columns have length 1 while others have length > 1, recycle the length-1 values
#' 3. If two columns both have length >= 2 but different lengths, error
#'
#' @noRd

handle_multi_column_explode <- function(data, col_names) {
  # Create length columns for each list column
  len_col_names <- paste0(".len_", col_names)

  len_exprs <- lapply(seq_along(col_names), function(i) {
    pl$col(col_names[i])$list$len()$alias(len_col_names[i])
  })
  data <- data$with_columns(!!!len_exprs)

  # Calculate max length per row (considering only lengths >= 1)
  # For NULL values, the length is 0, we need to handle them
  data <- data$with_columns(pl$max_horizontal(len_col_names)$alias(".max_len"))

  # Check for incompatible lengths: any column has length >= 2 and != max_len
  # This means we have n to m where n, m >= 2 and n != m
  incompatible_exprs <- lapply(len_col_names, function(len_col) {
    # Incompatible if: length >= 2 AND length != max_len
    pl$col(len_col)$gt(1L)$and(pl$col(len_col)$ne_missing(pl$col(".max_len")))
  })

  # Combine with OR to find any row with incompatible lengths
  any_incompatible <- Reduce(`|`, incompatible_exprs)

  # Check if any row has incompatible lengths
  # We need to collect to check this (unfortunately this breaks lazy evaluation)
  has_incompatible <- data$select(any_incompatible$any())
  if (inherits(has_incompatible, "polars_lazy_frame")) {
    has_incompatible <- has_incompatible$collect()
  }
  has_any_incompatible <- as.data.frame(has_incompatible)[[1]]
  if (isTRUE(has_any_incompatible)) {
    # Find the first problematic row to report a helpful error
    problem_data <- data$filter(any_incompatible)
    if (inherits(problem_data, "polars_lazy_frame")) {
      problem_data <- problem_data$collect()
    }
    first_problem <- problem_data$head(1L)
    lens <- vapply(
      len_col_names,
      function(nm) {
        as.data.frame(first_problem$select(nm))[[1]]
      },
      integer(1)
    )
    # Find sizes that are > 1
    sizes_gt_1 <- unique(lens[lens > 1])
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

  # For columns that need broadcasting:
  # - If max_len = 0 (all empty lists), replace [] with [""]
  # - If length is 0 (empty list from empty string) and max_len > 0, repeat [""] max_len times
  # - For null values and max_len > 0, repeat [null] max_len times
  # - If length is 1 and max_len > 1, repeat the single element max_len times
  repeat_exprs <- lapply(seq_along(col_names), function(i) {
    col_nm <- col_names[i]
    len_nm <- len_col_names[i]
    col <- pl$col(col_nm)
    len <- pl$col(len_nm)
    max_len <- pl$col(".max_len")

    # Case 1: max_len = 0 and column is not null - replace [] with [""]
    # Case 2: Empty list (len == 0) but not null column and max_len > 0 - repeat [""] max_len times
    # Case 3: Null value and max_len > 0 - repeat [null] max_len times
    # Case 4: Length 1 and max_len > 1 - repeat the element
    # Case 5: Otherwise keep original
    pl$when(
      # max_len = 0 and column is empty list (not null)
      max_len$eq(0)$and(len$eq(0))$and(col$is_null()$not())
    )$then(
      # Replace [] with [""]
      pl$lit(list(""))$cast(pl$List(pl$String))
    )$when(
      # Empty list (len == 0) but not null column and max_len > 0
      len$eq(0)$and(col$is_null()$not())$and(max_len$gt(0))
    )$then(
      # Create a list of empty strings repeated max_len times
      pl$lit("")$cast(pl$String)$repeat_by(max_len)
    )$when(
      # Null column and max_len > 0
      col$is_null()$and(max_len$gt(0))
    )$then(
      # Create a list of nulls repeated max_len times
      pl$lit(NULL)$cast(pl$String)$repeat_by(max_len)
    )$when(
      len$eq(1)$and(max_len$gt(1))
    )$then(
      # Single element - repeat it
      col$list$first()$repeat_by(max_len)
    )$otherwise(
      col
    )$alias(col_nm)
  })

  data$with_columns(!!!repeat_exprs)$drop(c(len_col_names, ".max_len"))
}
