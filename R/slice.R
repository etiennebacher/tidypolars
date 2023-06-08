#' Subset the first or last rows of a Data/LazyFrame
#'
#' @param data A Polars Data/LazyFrame
#' @param n The number of rows to select from the start or the end of the data.
#'
#' @rdname pl_slice
#' @export
#' @examples
#' pl_test <- pl$DataFrame(iris)
#' pl_slice_head(pl_test, 3)
#' pl_slice_tail(pl_test, 3)

pl_slice_tail <- function(data, n = 5) {
  data$slice(offset = -n, length = NULL)
}

#' @rdname pl_slice
#' @export
pl_slice_head <- function(data, n = 5) {
  data$slice(offset = 0, length = n)
}
