#' @export
rowwise.RPolarsDataFrame <- function(.data, ...) {
  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  # need to clone, otherwise the data gets attributes, even if unassigned
  .data2 <- .data$clone()

  if (!is.null(attributes(.data2)$pl_grps)) {
    rlang::abort("Cannot use `rowwise()` on grouped data.")
  }
  # attr(.data2, "pl_grps") <- vars
  attr(.data2, "grp_type") <- "rowwise"
  .data2
}

#' @rdname rowwise.RPolarsDataFrame
#' @export
rowwise.RPolarsLazyFrame <- rowwise.RPolarsDataFrame
