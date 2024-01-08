#' Summary statistics for a Polars DataFrame
#'
#' @inheritParams select.RPolarsDataFrame
#' @param percentiles One or more percentiles to include in the summary
#' statistics. All values must be between 0 and 1 (`NULL` are ignored).
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' mtcars |>
#'   as_polars_df() |>
#'   describe(percentiles = c(0.2, 0.4, 0.6, 0.8))

describe <- function(.data, percentiles = c(0.25, 0.75)) {
  if (!inherits(.data, "RPolarsDataFrame")) {
    rlang::abort("`describe()` can only be used on a DataFrame.")
  }
  between_zero_one <- percentiles >= 0 & percentiles <= 1
  if (anyNA(between_zero_one) || any(!between_zero_one)) {
    abort(
      "All values of `percentiles` must be between 0 and 1."
    )
  }
  .data$describe(percentiles)
}

