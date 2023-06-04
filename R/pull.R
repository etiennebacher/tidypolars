#' @export

pl_pull <- function(data, var) {
  check_polars_data(data)
  var <- deparse(substitute(var))
  data$select(pl$col(var))$to_series()
}
