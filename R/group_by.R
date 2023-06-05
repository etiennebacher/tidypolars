#' @export

pl_group_by <- function(data, ..., maintain_order = TRUE) {
  check_polars_data(data)
  vars <- .select_nse(data, ...)
  data$groupby(vars, maintain_order = maintain_order)
}
