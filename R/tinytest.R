#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_colnames <- function(x, y) {
  if (inherits(x, "RPolarsLazyFrame")) {
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
  if (inherits(x, "RPolarsLazyFrame")) {
    x <- x$collect()
  }
  res <- all.equal(dim(x), y)
  tinytest::tinytest(
    result = res,
    call = sys.call(sys.parent(1))
  )
}

#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_equal <- function(x, y, ...) {
  if (inherits(x, "RPolarsDataFrame")) {
    x <- x$to_data_frame()
  }
  if (inherits(y, "RPolarsDataFrame")) {
    y <- y$to_data_frame()
  }
  tinytest::expect_equal(
    x, y,
    call = sys.call(sys.parent(2)),
    ...
  )
}

#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_equal_lazy <- function(x, y, ...) {
  if (inherits(x, "RPolarsLazyFrame")) {
    x <- x$collect()
  }
  if (inherits(y, "RPolarsLazyFrame")) {
    y <- y$collect()
  }
  dots <- get_dots(...)
  if (isTRUE(dots$skip_for_lazy)) {
    message("Test skipped for LazyFrame")
    return(invisible())
  }
  tinytest::expect_equal(
    x, y,
    call = sys.call(sys.parent(2)),
    ...
  )
}

#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_error_lazy <- function(current, pattern = ".*", ...) {
  tinytest::expect_error(current$collect(), pattern, ...)
}

test_all_tidypolars <- function() {
  source("tests/tinytest/setup.R")
  tinytest::test_all(testdir = "tests/tinytest")
}

#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_is_tidypolars <- function(x) {
  tinytest::expect_true(inherits(x, "tidypolars"))
}
