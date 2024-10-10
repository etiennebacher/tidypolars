#' @inherit summary.RPolarsDataFrame title params
#'
#' @param .data A Polars DataFrame.
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function is deprecated as of tidypolars 0.10.0, it will be removed in
#' a future update. Use `summary()` with the same arguments instead.
#'
#' @export

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
  out <- .data$describe(percentiles)
  out
}

