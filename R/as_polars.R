#' @export

as_polars <- function(data, lazy = FALSE) {
  if (isTRUE(lazy)) {
    pl$DataFrame(data)$lazy()
  } else {
    pl$DataFrame(data)
  }
}
