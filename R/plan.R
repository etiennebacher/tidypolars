#' @inherit explain.RPolarsLazyFrame title
#'
#' @description
#' Those functions are deprecated as of tidypolars 0.10.0, they will be removed
#' in a future update. Use `explain()` with `optimized = FALSE` to recover the
#' output of `describe_plan()`, and with `optimized = TRUE` (the default) to
#' get the output of `describe_optimized_plan()`.
#'
#' @param .data A Polars LazyFrame
#' @export

# nocov start
describe_plan <- function(.data) {
  if (!inherits(.data, "RPolarsLazyFrame")) {
    rlang::abort("`describe_plan()` only works on a LazyFrame.")
  }
  rlang::warn("`describe_plan()` is deprecated as of tidypolars 0.10.0 and will be removed in a future update.\nUse `explain()` with `optimized = FALSE` instead.")
  .data$describe_plan()
}

#' @export
#' @rdname describe_plan

describe_optimized_plan <- function(.data) {
  if (!inherits(.data, "RPolarsLazyFrame")) {
    rlang::abort("`describe_optimized_plan()` only works on a LazyFrame.")
  }
  rlang::warn("`describe_optimized_plan()` is deprecated as of tidypolars 0.10.0 and will be removed in a future update.\nUse `explain()` with `optimized = TRUE` instead.")
  .data$describe_optimized_plan()
}
# nocov end
