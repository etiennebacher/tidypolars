#' Create a column with unique id per row values
#'
#' @inheritParams fill.RPolarsDataFrame
#' @param new_col Name of the new column
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' mtcars |>
#'   as_polars_df() |>
#'   make_unique_id(am, gear)

make_unique_id <- function(.data, ..., new_col = "hash") {
  check_polars_data(.data)
  if (new_col %in% names(.data)) {
    cli_abort(
      paste0(
        'Column "',
        new_col,
        '" already exists. Use a new name with the argument `new_col`.'
      )
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
