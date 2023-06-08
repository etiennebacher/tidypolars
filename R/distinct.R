#' @export
pl_distinct <- function(data, ..., keep = "first") {
  check_polars_data(data)
  dots <- get_dots(...)

  vars <- unlist(dots)
  vars <- vars[vars %in% pl_colnames(data)]
  if (length(vars) >= 1) {
    expr <- paste0("c('", paste(dots, collapse = "', '"), "')") |>
      str2lang()
  } else {
    expr <- NULL
  }

  # TODO: arg maintain_order is not implemented in r-polars
  data$unique(subset = eval(expr), keep = keep)
}

