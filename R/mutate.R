#' @export

pl_mutate <- function(data, ...) {

  check_polars_data(data)

  dots <- get_dots(...)
  out_exprs <- rearrange_exprs(data, dots)

  out_exprs <- unlist(out_exprs)
  out_exprs <- paste(out_exprs, collapse = ", ")

  paste0("data$with_columns(", out_exprs, ")") |>
    str2lang() |>
    eval()
}
