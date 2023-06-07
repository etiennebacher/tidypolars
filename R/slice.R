#' @export
pl_slice_tail <- function(data, n = 5) {
  data$slice(offset = -n, length = NULL)
}

#' @export
pl_slice_head <- function(data, n = 5) {
  data$slice(offset = 0, length = n)
}
