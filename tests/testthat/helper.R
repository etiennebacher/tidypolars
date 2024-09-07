expect_equal_or_both_error <- function(object, n) {
  polars_error <- FALSE
  polars_res <- tryCatch(
    object,
    error = function(e) polars_error <<- TRUE
  )

  other_error <- FALSE
  other_res <- suppressWarnings(
    tryCatch(
      object,
      error = function(e) other_error <<- TRUE
    )
  )

  if (isTRUE(polars_error)) {
    testthat::expect(isTRUE(other_error), "tidypolars errored but tidyverse didn't.")
  } else {
    testthat::expect_equal(polars_res, other_res)
  }

  invisible(NULL)
}
