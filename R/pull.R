#' @export

pl_pull <- function(data, var) {

  var <- deparse(substitute(var))

  if (inherits(data, "DataFrame")) {
    data$select(pl$col(var))$to_series()
  }

}
