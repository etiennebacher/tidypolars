#' @export
#' @keywords internal
expect_colnames <- function(x, y) {
  res <- identical(x$columns, y)
  tinytest(
    result = res,
    call = sys.call(sys.parent(1))
  )
}

#' @export
#' @keywords internal
expect_dim <- function(x, y) {
  res <- identical(dim(x), y)
  tinytest(
    result = res,
    call = sys.call(sys.parent(1))
  )
}
