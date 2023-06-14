#' @export

pl_group_by <- function(data, ..., maintain_order = TRUE) {
  check_polars_data(data)
  vars <- .select_nse_from_dots(data, ...)

  # we can't access column names on a "GroupBy" object so I save them as an
  # attribute before
  names <- pl_colnames(data)
  data <- data$groupby(vars, maintain_order = maintain_order)
  attr(data, "pl_colnames") <- names
  attr(data, "pl_grps") <- vars
  data
}

#' @export

pl_ungroup <- function(data) {
  if (inherits(data, "GroupBy")) {
    class(data) <- "DataFrame"
    attributes(data)$pl_grps <- NULL
  } else {
    if (inherits(data, "LazyGroupBy")) {
      class(data) <- "LazyFrame"
      attributes(data)$pl_grps <- NULL
    }
  }
  data
}
