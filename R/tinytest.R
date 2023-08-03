#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_colnames <- function(x, y) {
  if (inherits(x, "LazyFrame")) {
    x <- x$collect()
  }
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
  if (inherits(x, "LazyFrame")) {
    x <- x$collect()
  }
  res <- identical(dim(x), y)
  tinytest::tinytest(
    result = res,
    call = sys.call(sys.parent(1))
  )
}

#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_equal_lazy <- function(x, y, ...) {
  if (inherits(x, "LazyFrame")) {
    x <- x$collect()
  }
  if (inherits(y, "LazyFrame")) {
    y <- y$collect()
  }
  tinytest::expect_equal(
    x, y,
    call = sys.call(sys.parent(2))
  )
}

#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_error_lazy <- function(current, pattern, ...) {
  tinytest::expect_error(current$collect(), pattern, ...)
}

test_all_tidypolars <- function() {
  source("tests/tinytest/setup.R")
  tinytest::test_all(testdir = "tests/tinytest")
}
