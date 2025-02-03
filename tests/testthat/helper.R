expect_equal_or_both_error <- function(object, other, ...) {
  polars_error <- FALSE
  polars_res <- tryCatch(
    object,
    error = function(e) polars_error <<- TRUE
  )

  other_error <- FALSE
  other_res <- suppressWarnings(
    tryCatch(
      other,
      error = function(e) other_error <<- TRUE
    )
  )

  if (isTRUE(polars_error)) {
    testthat::expect(
      isTRUE(other_error),
      "tidypolars errored but tidyverse didn't."
    )
  } else {
    expect_equal(polars_res, other_res, ...)
  }

  invisible(NULL)
}

expect_colnames <- function(x, y) {
  if (inherits(x, "RPolarsLazyFrame")) {
    x <- x$collect()
  }
  testthat::expect_equal(x$columns, y)
}

expect_dim <- function(x, y) {
  if (inherits(x, "RPolarsLazyFrame")) {
    x <- x$collect()
  }
  testthat::expect_equal(dim(x), y)
}

expect_equal <- function(x, y, ...) {
  if (inherits(x, "RPolarsDataFrame")) {
    x <- x$to_data_frame()
  }
  if (inherits(y, "RPolarsDataFrame")) {
    y <- y$to_data_frame()
  }
  testthat::expect_equal(x, y, ...)
}

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
  testthat::expect_equal(x, y, ...)
}

expect_error_lazy <- function(current, pattern = ".*", ...) {
  testthat::expect_error(current$collect(), pattern, ...)
}

expect_snapshot <- function(...) {
  withr::with_options(
    list(polars.do_not_repeat_call = TRUE),
    testthat::expect_snapshot(...)
  )
}
expect_snapshot_lazy <- function(current, ...) {
  withr::with_options(
    list(polars.do_not_repeat_call = TRUE),
    testthat::expect_snapshot(current$collect(), ...)
  )
}

test_this_file <- function() {
  file <- rstudioapi::getSourceEditorContext()$path
  if (!grepl("testthat/", file)) {
    message("Must run this when the active window is a test file.")
    return(invisible())
  }
  testthat::run_test_file(file)
}

expect_is_tidypolars <- function(x) {
  testthat::expect_true(inherits(x, "tidypolars"))
}
