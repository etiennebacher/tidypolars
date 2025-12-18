expect_equal_or_both_error <- function(object, other, ...) {
  polars_error <- FALSE
  polars_res <- tryCatch(
    object,
    error = function(e) {
      # nolint: implicit_assignment
      polars_error <<- TRUE
    }
  )

  other_error <- FALSE
  other_res <- suppressWarnings(
    tryCatch(
      other,
      error = function(e) {
        # nolint: implicit_assignment
        other_error <<- TRUE
      }
    )
  )

  if (isTRUE(polars_error)) {
    testthat::expect(
      isTRUE(other_error),
      "tidypolars errored but tidyverse didn't."
    )
  } else {
    if (isTRUE(other_error)) {
      testthat::expect(
        isTRUE(polars_error),
        "tidyverse errored but tidypolars didn't."
      )
    } else if (is_polars_lf(polars_res)) {
      expect_equal_lazy(polars_res, other_res, ...)
    } else {
      expect_equal(polars_res, other_res, ...)
    }
  }

  invisible(NULL)
}

expect_colnames <- function(x, y) {
  if (is_polars_lf(x)) {
    x <- x$collect()
  }
  testthat::expect_equal(x$columns, y)
}

expect_dim <- function(x, y) {
  if (is_polars_lf(x)) {
    x <- x$collect()
  }
  testthat::expect_equal(dim(x), y)
}

expect_equal <- function(x, y, ...) {
  if (is_polars_df(x)) {
    x <- as.data.frame(x)
  }
  if (is_polars_df(y)) {
    y <- as.data.frame(y)
  }
  testthat::expect_equal(x, y, ...)
}

expect_equal_lazy <- function(x, y, ...) {
  if (is_polars_lf(x)) {
    x <- as.data.frame(x)
  }
  if (is_polars_lf(y)) {
    y <- as.data.frame(y)
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
  testthat::expect_snapshot(...)
}
expect_snapshot_lazy <- function(current, ...) {
  testthat::expect_snapshot(current$collect(), ...)
}

test_this_file <- function() {
  file <- rstudioapi::getSourceEditorContext()$path
  if (!grepl("testthat/", file, fixed = TRUE)) {
    message("Must run this when the active window is a test file.")
    return(invisible())
  }
  testthat::run_test_file(file)
}

expect_is_tidypolars <- function(x) {
  testthat::expect_true(inherits(x, "tidypolars"))
}
