#' @export
pl_drop_na <- function(data, ...) {
  check_polars_data(data)
  dots <- get_dots(...)

  vars <- unlist(dots)
  vars <- vars[vars %in% pl_colnames(data)]
  if (length(vars) >= 1) {
    expr <- paste0("pl$col(c('", paste(dots, collapse = "', '"), "'))") |>
      str2lang()
  } else {
    expr <- NULL
  }

  data$drop_nulls(eval(expr))
}

