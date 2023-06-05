#' @export

pl_group_by <- function(data, ..., maintain_order = TRUE) {
  check_polars_data(data)
  vars <- .select_nse(data, ...)

  # we can't access column names on a "GroupBy" object so I save them as an
  # attribute before
  names <- pl_colnames(data)
  data <- data$groupby(vars, maintain_order = maintain_order)
  attr(data, "pl_colnames") <- names

  data
}
