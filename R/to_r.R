#' Convert a Polars DataFrame to an R data.frame
#'
#' This is a simple wrapper of `$to_data_frame()` present in `polars`. This is
#' only to make this function work in a pipe workflow.
#'
#' @param .data A Polars DataFrame only (LazyFrames are not modified). Any other
#' object is returned as-is.
#' @param shrink_i64 Try to shrink i64 to i32 or lower. See Details.
#'
#' @details
#' Int64 is a format accepted in Polars but not natively in R (the package `bit64`
#' helps with that). Therefore, int64 values will give infinitely small values
#' when converted to R. If `shrink_i64` is `TRUE`, int64 columns will be shrunk
#' to a lower int before being converted to R.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' iris |>
#'   as_polars() |>
#'   filter(Sepal.Length > 6) |>
#'   to_r()

to_r <- function(.data, shrink_i64 = TRUE) {

  if (isTRUE(shrink_i64)) {
    i64_cols <- which(sapply(.data$schema, \(x) x == pl$Int64))
    if (length(i64_cols) > 0) {
      .data <- .data$with_columns(
        pl$col(names(i64_cols))$shrink_dtype()
      )
    }
  }

  # for testing only
  if (inherits(.data, "LazyFrame") && Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
    return(.data$collect()$to_data_frame())
  }

  if (inherits(.data, "DataFrame")) {
    .data$to_data_frame()
  }
}
