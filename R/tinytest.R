#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_colnames <- function(x, y) {
  res <- identical(x$columns, y)
  tinytest::tinytest(
    result = res,
    call = sys.call(sys.parent(1))
  )
}

#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_dim <- function(x, y) {
  res <- identical(dim(x), y)
  tinytest::tinytest(
    result = res,
    call = sys.call(sys.parent(1))
  )
}
