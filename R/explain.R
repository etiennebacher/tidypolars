#' Show the optimized and non-optimized query plans
#'
#' @description
#' This function is available for `LazyFrame`s only.
#'
#' By default, `explain()` shows the query plan that is optimized and then run
#' by Polars. Setting `optimized = FALSE` shows the query plan as-is, without
#' any optimization done, but this is not the query performed. Note that the
#' plans are read from bottom to top.
#'
#' @param x A Polars LazyFrame.
#' @param optimized Logical. If `TRUE` (default), show the query optimized by
#' Polars. Otherwise, show the initial query.
#' @inheritParams summary.RPolarsDataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' query <- mtcars |>
#'   as_polars_lf() |>
#'   arrange(drat) |>
#'   filter(cyl == 3) |>
#'   select(mpg)
#'
#' # unoptimized query plan:
#' no_opt <- explain(query, optimized = FALSE)
#' no_opt
#'
#' # better printing with cat():
#' cat(no_opt)
#'
#' # optimized query run by polars
#' cat(explain(query))
# nocov start
explain.RPolarsLazyFrame <- function(x, optimized = TRUE, ...) {
  x$explain(optimized = optimized)
}
# nocov end
