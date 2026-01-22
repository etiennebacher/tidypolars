#' Create a column with unique id per row values
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' The underlying Polars function isn't guaranteed to give the same results
#' across different versions. Therefore, this function will be removed and has
#' no replacement in `tidypolars`.
#'
#' @inheritParams fill.polars_data_frame
#' @param new_col Name of the new column
#'
#' @export
make_unique_id <- function(.data, ..., new_col = "hash") {
  lifecycle::deprecate_warn(
    when = "0.16.0",
    what = "make_unique_id()",
    details = c(
      "This has no guarantee of giving the same results across Polars versions.",
      "It has no replacement in `tidypolars`."
    ),
    always = TRUE,
  )
  check_polars_data(.data)
  if (new_col %in% names(.data)) {
    cli_abort(
      'Column {.val {new_col}} already exists. Use a new name with the argument {.code new_col}.'
    )
  }
  vars <- tidyselect_dots(.data, ...)
  if (length(vars) == 0) {
    vars <- names(.data)
  }
  out <- .data$with_columns(
    pl$struct(vars)$hash()$alias(new_col)
  )
  add_tidypolars_class(out)
}
