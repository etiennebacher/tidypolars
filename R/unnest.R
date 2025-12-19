#' Unnest a list-column into rows
#'
#' `unnest_longer_polars()` turns each element of a list-column into a row.
#' This is a polars-specific implementation based on `polars$explode()`.
#'
#' @param data A Polars DataFrame or LazyFrame.
#' @param col <[`tidy-select`][tidyr_tidy_select]> Column(s) to unnest. Can be
#'   bare column names, character strings, or tidyselect expressions. When
#'   selecting multiple columns, the list elements in each row must have the
#'   same length across all selected columns.
#' @param ... These dots are for future extensions and must be empty.
#' @param values_to A string giving the column name to store the unnested values
#'   in. If `NULL` (the default), the original column name is used. When
#'   multiple columns are selected, this can be a glue string containing
#'   `"{col}"` to provide a template for the column names (e.g.,
#'   `values_to = "{col}_val"`).
#' @param indices_to A string giving the column name to store the index of the
#'   values. If `NULL` (the default), no index column is created. When multiple
#'   columns are selected, this can be a glue string containing `"{col}"` to
#'   create separate index columns for each unnested column (e.g.,
#'   `indices_to = "{col}_idx"`).
#' @param keep_empty If `TRUE`, empty values (NULL or empty lists) are kept as
#'   `NA` in the output. If `FALSE` (the default), empty values are dropped.
#'
#' @return A Polars DataFrame or LazyFrame with the list-column(s) unnested into
#'   rows.
#'
#' @details
#' When multiple columns are selected, the corresponding list elements from each
#' row are expanded together. This requires that all selected columns have lists
#' of the same length in each row.
#'
#' The `indices_to` parameter creates an integer column with the position
#' (1-indexed) of each element within the original list. Named elements in the
#' list are not currently supported for index names (they will use integer
#' positions).
#'
#' When using `"{col}"` templates with multiple columns, the template is applied
#' to each column name to generate the output column names.
#'
#' @seealso [tidyr::unnest_longer()] for the tidyr equivalent.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' library(polars)
#'
#' # Basic example with a list column
#' df <- pl$DataFrame(
#'   id = 1:3,
#'   values = list(c(1, 2), c(3, 4, 5), 6)
#' )
#' df
#'
#' unnest_longer_polars(df, values)
#'
#' # With indices
#' unnest_longer_polars(df, values, indices_to = "idx")
#'
#' # Rename the output column
#' unnest_longer_polars(df, values, values_to = "val")
#'
#' # Multiple columns - list elements must have same length per row
#' df2 <- pl$DataFrame(
#'   id = 1:2,
#'   a = list(c(1, 2), c(3, 4)),
#'   b = list(c("x", "y"), c("z", "w"))
#' )
#' unnest_longer_polars(df2, c(a, b))
#'
#' # Multiple columns with values_to template
#' unnest_longer_polars(df2, c(a, b), values_to = "{col}_val")
#'
#' # Multiple columns with indices_to template
#' unnest_longer_polars(df2, c(a, b), indices_to = "{col}_idx")
#'
#' # Example with strings split into a list
#' df3 <- pl$DataFrame(
#'   id = 1:2,
#'   tags = list(c("apple", "banana"), c("grape", "pear"))
#' )
#'
#' unnest_longer_polars(df3, tags)
#'
#' # keep_empty example
#' df4 <- pl$DataFrame(
#'   id = 1:3,
#'   values = list(c(1, 2), NULL, 3)
#' )
#'
#' # By default, NULL/empty values are dropped
#' unnest_longer_polars(df4, values)
#'
#' # Use keep_empty = TRUE to keep them as NA
#' unnest_longer_polars(df4, values, keep_empty = TRUE)
unnest_longer_polars <- function(
  data,
  col,
  ...,
  values_to = NULL,
  indices_to = NULL,
  keep_empty = FALSE
) {
  check_polars_data(data)
  rlang::check_dots_empty()

  # Capture the column expression
  col_names <- tidyselect_named_arg(data, rlang::enquo(col))

  if (length(col_names) == 0) {
    cli_abort(
      "Column not found.",
      call = caller_env()
    )
  }

  check_string(values_to, allow_null = TRUE)
  check_string(indices_to, allow_null = TRUE)
  check_bool(keep_empty)

  # Check if templates contain {col}
  values_to_is_template <- is_col_template(values_to)
  indices_to_is_template <- is_col_template(indices_to)

  # values_to without template is only supported for single column
  if (!is.null(values_to) && length(col_names) > 1 && !values_to_is_template) {
    cli_abort(
      c(
        paste0(
          "{.arg values_to} must contain {.code {{col}}} when multiple ",
          "columns are selected."
        ),
        "i" = "You provided {length(col_names)} columns: {.val {col_names}}."
      ),
      call = caller_env()
    )
  }

  # indices_to without template is only supported for single column
  if (
    !is.null(indices_to) && length(col_names) > 1 && !indices_to_is_template
  ) {
    cli_abort(
      c(
        paste0(
          "{.arg indices_to} must contain {.code {{col}}} when multiple ",
          "columns are selected."
        ),
        "i" = "You provided {length(col_names)} columns: {.val {col_names}}."
      ),
      call = caller_env()
    )
  }

  # Generate new column names from template
  values_to_names <- expand_col_template(values_to, col_names)
  indices_to_names <- expand_col_template(indices_to, col_names)

  # If indices_to is provided, we need to add an index column before exploding
  if (!is.null(indices_to)) {
    # First add a row number to track original rows
    temp_row_id <- paste0("__tidypolars_row_id_", sample.int(1e6, 1), "__")

    data <- data$with_row_index(name = temp_row_id)

    # Explode the column(s)
    out <- data$explode(col_names)

    # Create the index column(s)
    if (indices_to_is_template) {
      # Create multiple index columns with template names
      # First create the base index
      temp_idx <- paste0("__tidypolars_idx_", sample.int(1e6, 1), "__")
      out <- out$with_columns(
        (pl$col(temp_row_id)$cum_count()$over(pl$col(temp_row_id)))$alias(
          temp_idx
        )
      )
      # Copy to all template column names
      for (idx_name in indices_to_names) {
        out <- out$with_columns(pl$col(temp_idx)$alias(idx_name))
      }
      out <- out$drop(temp_idx)
    } else {
      # Single index column
      out <- out$with_columns(
        (pl$col(temp_row_id)$cum_count()$over(pl$col(temp_row_id)))$alias(
          indices_to
        )
      )
    }

    # Remove the temporary row id
    out <- out$drop(temp_row_id)
  } else {
    # Simply explode without indices
    out <- data$explode(col_names)
  }

  # Handle keep_empty
  if (!keep_empty) {
    out <- out$drop_nulls(col_names)
  }

  # Rename columns if values_to is provided
  if (!is.null(values_to)) {
    if (values_to_is_template) {
      # Rename each column according to template
      out <- out$rename(!!!as.list(values_to_names))
    } else if (length(col_names) == 1 && values_to != col_names[1]) {
      # Single column rename
      mapping <- stats::setNames(list(values_to), col_names[1])
      out <- out$rename(!!!mapping)
    }
  }

  add_tidypolars_class(out)
}


# Expand a template string containing `{col}` for each column name
#
# @param template A string that may contain `{col}` as a placeholder.
# @param col_names A character vector of column names to substitute.
#
# @return If template is NULL, returns NULL. If template contains `{col}`,
#   returns a named character vector where values are the expanded names and
#   names are the original column names. Otherwise returns the template as-is.
#
# @noRd
expand_col_template <- function(template, col_names) {
  if (is.null(template)) {
    return(NULL)
  }

  is_template <- grepl("\\{col\\}", template)

  if (is_template) {
    result <- vapply(
      col_names,
      function(x) gsub("\\{col\\}", x, template),
      FUN.VALUE = character(1)
    )
    names(result) <- col_names
    return(result)
  }

  template
}

# Check if a string is a `{col}` template
#
# @param x A string or NULL.
#
# @return TRUE if x contains `{col}`, FALSE otherwise.
#
# @noRd
is_col_template <- function(x) {
  !is.null(x) && grepl("\\{col\\}", x)
}
