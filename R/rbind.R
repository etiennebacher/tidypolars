#' @export
pl_rbind <- function(x, y) {
  check_polars_data(x)
  check_polars_data(y)
  check_same_class(x, y)

  # TODO: not implemented in r-polars yet
  # x$hstack(y)
}

# TODO: same thing for cbind (need the concat() method for DataFrame to be
# implemented in r-polars yet)
