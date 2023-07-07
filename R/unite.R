#' @export
pl_unite <- function(.data, col, ..., sep = "_", remove = TRUE, na.rm = FALSE) {

  check_polars_data(.data)
  dots <- get_dots(...)

  # TODO: concat_str() not implemented in r-polars yet
  # .data$with_columns(pl$concat_str(eval(dots))$alias(col))
}
