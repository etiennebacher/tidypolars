#' @export
pl_distinct <- function(data, ..., keep = "first", maintain_order = TRUE) {
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

  data$unique(subset = eval(expr), keep = keep, maintain_order = maintain_order)
}

