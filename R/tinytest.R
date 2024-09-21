#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_colnames <- function(x, y) {
  if (inherits(x, "RPolarsLazyFrame")) {
    x <- x$collect()
  }
  tinytest::expect_equal(
    x$columns, y,
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
  tinytest::expect_equal(
    dim(x), y,
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
    x <- x$collect()$to_data_frame()
  }
  if (inherits(y, "RPolarsLazyFrame")) {
    y <- y$collect()$to_data_frame()
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

test_this_file <- function() {
  file <- rstudioapi::getSourceEditorContext()$path
  if (!grepl("tinytest/", file)) {
    message("Must run this when the active window is a test file.")
    return(invisible())
  }
  tinytest::run_test_file(file)
}

#' `tinytest` helper
#'
#' @export
#' @keywords internal
expect_is_tidypolars <- function(x) {
  tinytest::expect_true(inherits(x, "tidypolars"))
}
