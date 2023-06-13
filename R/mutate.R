#' @export

pl_mutate <- function(data, ...) {

  check_polars_data(data)

  dots <- get_dots(...)
  out_exprs <- rearrange_exprs(data, dots)

  for (i in out_exprs) {
    data <- data$with_columns(
      eval(str2lang(i))
    )
  }
  data
}
