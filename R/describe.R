#' @inherit summary.RPolarsDataFrame title params
#'
#' @param .data A Polars DataFrame.
#'
#' @description
#' This function is deprecated as of tidypolars 0.10.0, it will be removed in
#' a future update. Use `summary()` with the same arguments instead.
#'
#' @export

describe <- function(.data, percentiles = c(0.25, 0.75)) {
  if (!inherits(.data, "RPolarsDataFrame")) {
    rlang::abort("`describe()` can only be used on a DataFrame.")
  }
  rlang::warn("`describe()` is deprecated as of tidypolars 0.10.0 and will be removed in a future update.\nUse `summary()` with the same arguments instead.")
  summary(object = .data, percentiles = percentiles)
}

