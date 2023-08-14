#' Convert a Polars DataFrame to an R data.frame
#'
#' This is a simple wrapper of `$to_data_frame()` present in `polars`. This is
#' only make this function work in a pipe workflow.
#'
#' @param .data A Polars DataFrame only (LazyFrames are not modified). Any other
#' object is returned as-is.
#'
#' @export
#' @examples
#' iris |>
#'   as_polars() |>
#'   pl_filter(Sepal.Length > 6) |>
#'   to_r()

to_r <- function(.data) {

  # for testing only
  if (inherits(.data, "LazyFrame") && Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
    return(.data$collect()$to_data_frame())
  }

  if (inherits(.data, "DataFrame")) {
    .data$to_data_frame()
  }
}
