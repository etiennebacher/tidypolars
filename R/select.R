#' @export

pl_select <- function(data, ...) {

  check_polars_data(data)

  vars <- .select_nse(data, ...)

  expr <- paste0("pl$col(c('", paste(vars, collapse = "', '"), "'))") |>
    str2lang()

  if (inherits(data, "DataFrame")) {
    data$select(eval(expr))
  }

}
