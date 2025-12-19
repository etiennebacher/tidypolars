#' Unnest a list-column into rows
#'
#' `unnest_longer_polars()` turns each element of a list-column into a row.
#' This is the equivalent of `tidyr::unnest_longer()`.
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
  rlang::check_required(col)

  # Capture the column expression
  col_names <- tidyselect_named_arg(data, rlang::enquo(col))

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
      )
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
      )
    )
  }

  # Generate new column names from template
  values_to_names <- expand_col_template(values_to, col_names)
  indices_to_names <- expand_col_template(indices_to, col_names)

  # Filter to only list/array columns (like tidyr behavior)
  # Non-list columns are silently ignored
  schema <- data$collect_schema()
  list_col_names <- Filter(
    function(nm) {
      dtype <- schema[[nm]]
      inherits(dtype, "polars_dtype_list") ||
        inherits(dtype, "polars_dtype_array")
    },
    col_names
  )

  # If no list columns, return data unchanged (like tidyr)
  if (length(list_col_names) == 0) {
    return(add_tidypolars_class(data))
  }

  # Update col_names to only include list columns
  col_names <- list_col_names

  # Check for column name conflicts
  check_unnest_names(
    data_names = names(schema),
    col_names = col_names,
    values_to = values_to,
    values_to_names = values_to_names,
    values_to_is_template = values_to_is_template,
    indices_to = indices_to,
    indices_to_names = indices_to_names,
    indices_to_is_template = indices_to_is_template,
    call = rlang::current_env()
  )

  # Regenerate template names since col_names may have changed
  values_to_names <- expand_col_template(values_to, col_names)
  indices_to_names <- expand_col_template(indices_to, col_names)

  # If indices_to is provided, use struct approach to ensure index columns
  # are placed immediately after their value columns
  if (!is.null(indices_to)) {
    # Create temporary row id for tracking original rows
    temp_row_id <- paste0("__tidypolars_row_id_", sample.int(1e6, 1), "__")
    out <- data$with_row_index(name = temp_row_id)

    # Explode the value columns
    out <- out$explode(col_names)

    # For each value column, convert to struct and add index field, then unnest
    for (i in seq_along(col_names)) {
      col_nm <- col_names[i]
      idx_nm <- if (indices_to_is_template) indices_to_names[i] else indices_to

      # Convert value column to struct, add index field, then unnest
      out <- out$with_columns(
        pl$struct(col_nm)
      )$with_columns(
        pl$col(col_nm)$struct$with_fields(
          (pl$field(col_nm)$cum_count()$over(pl$col(temp_row_id)))$alias(idx_nm)
        )
      )$with_columns(
        pl$struct(
          pl$col(col_nm)$struct$field(idx_nm),
          pl$col(col_nm)$struct$field(col_nm)
        )$alias(col_nm)
      )$unnest(col_nm)
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


#' Check for column name conflicts in unnest operations
#'
#' @param data_names Character vector of existing column names in the data.
#' @param col_names Character vector of columns being unnested.
#' @param values_to The values_to parameter (string or NULL).
#' @param values_to_names Expanded values_to names (from template or original).
#' @param values_to_is_template Whether values_to is a template.
#' @param indices_to The indices_to parameter (string or NULL).
#' @param indices_to_names Expanded indices_to names (from template or original).
#' @param indices_to_is_template Whether indices_to is a template.
#' @param call The calling environment for error reporting.
#'
#' @noRd
check_unnest_names <- function(
  data_names,
  col_names,
  values_to,
  values_to_names,
  values_to_is_template,
  indices_to,
  indices_to_names,
  indices_to_is_template,
  call = rlang::caller_env()
) {
  # Compute final value column names
  if (!is.null(values_to)) {
    if (values_to_is_template) {
      final_val_names <- unname(values_to_names)
    } else {
      final_val_names <- values_to
    }
  } else {
    final_val_names <- col_names
  }

  # Compute final index column names
  if (!is.null(indices_to)) {
    if (indices_to_is_template) {
      final_idx_names <- unname(indices_to_names)
    } else {
      final_idx_names <- indices_to
    }
  } else {
    final_idx_names <- character(0)
  }

  # Check 1: Duplicates between values_to and indices_to
  if (length(final_idx_names) > 0) {
    dup_val_idx <- intersect(final_val_names, final_idx_names)
    if (length(dup_val_idx) > 0) {
      cli_abort(
        c(
          "Names must be unique.",
          "x" = "These names are duplicated:",
          "*" = "{.val {dup_val_idx}}, from both {.arg values_to} and {.arg indices_to}."
        ),
        call = call
      )
    }
  }

  # Columns that will remain after unnesting (excluding the unnested cols)
  other_cols <- setdiff(data_names, col_names)

  # Check 2: indices_to conflicts with existing columns
  if (length(final_idx_names) > 0) {
    dup_idx_data <- intersect(final_idx_names, other_cols)
    if (length(dup_idx_data) > 0) {
      # Find which col_names produced these conflicts
      if (indices_to_is_template) {
        sources <- names(indices_to_names)[
          unname(indices_to_names) %in% dup_idx_data
        ]
      } else {
        sources <- col_names[1]
      }
      cli_abort(
        c(
          "Can't duplicate names between the affected columns and the original data.",
          "x" = "These names are duplicated:",
          "i" = "{.val {dup_idx_data}}, from {.val {sources}}."
        ),
        call = call
      )
    }
  }

  # Check 3: values_to conflicts with existing columns
  if (!is.null(values_to)) {
    dup_val_data <- intersect(final_val_names, other_cols)
    if (length(dup_val_data) > 0) {
      if (values_to_is_template) {
        sources <- names(values_to_names)[
          unname(values_to_names) %in% dup_val_data
        ]
      } else {
        sources <- col_names[1]
      }
      cli_abort(
        c(
          "Can't duplicate names between the affected columns and the original data.",
          "x" = "These names are duplicated:",
          "i" = "{.val {dup_val_data}}, from {.val {sources}}."
        ),
        call = call
      )
    }
  }

  invisible(NULL)
}


#' Expand a template string containing `{col}` for each column name
#'
#' @param template A string that may contain `{col}` as a placeholder.
#' @param col_names A character vector of column names to substitute.
#'
#' @return If template is NULL, returns NULL. If template contains `{col}`,
#'   returns a named character vector where values are the expanded names and
#'   names are the original column names. Otherwise returns the template as-is.
#'
#' @noRd
expand_col_template <- function(template, col_names) {
  if (is_col_template(template)) {
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

#' Check if a string is a `{col}` template
#'
#' @param x A string or NULL.
#'
#' @return TRUE if x contains `{col}`, FALSE otherwise.
#'
#' @noRd
is_col_template <- function(x) {
  !is.null(x) && grepl("\\{col\\}", x)
}
