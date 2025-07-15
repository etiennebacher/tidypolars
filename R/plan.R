#' @inherit explain.polars_lazy_frame title
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' Those functions are deprecated as of tidypolars 0.10.0, they will be removed
#' in a future update. Use `explain()` with `optimized = FALSE` to recover the
#' output of `describe_plan()`, and with `optimized = TRUE` (the default) to
#' get the output of `describe_optimized_plan()`.
#'
#' @param .data A Polars LazyFrame
#' @export

# nocov start
describe_plan <- function(.data) {
  if (!is_polars_lf(.data)) {
    cli_abort("{.fn describe_plan} only works on a LazyFrame.")
  }
  lifecycle::deprecate_warn(
    when = "0.10.0",
    what = "describe_plan()",
    details = "Please use `explain(optimized = FALSE)` instead."
  )
  .data$describe_plan()
}

#' @export
#' @rdname describe_plan

describe_optimized_plan <- function(.data) {
  if (!is_polars_lf(.data)) {
    cli_abort("{.fn describe_optimized_plan} only works on a LazyFrame.")
  }
  lifecycle::deprecate_warn(
    when = "0.10.0",
    what = "describe_optimized_plan()",
    details = "Please use `explain()` instead."
  )
  .data$describe_optimized_plan()
}
# nocov end
