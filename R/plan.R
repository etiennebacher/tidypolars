#' Show the optimized and non-optimized query plans
#'
#' These functions are available for `LazyFrame`s only. `describe_plan()` shows
#' the query plan as-is, without any optimization done by Polars. This is not
#' the query performed. Before running the query, Polars applies a list of
#' optimizations (such as filtering data before sorting it). The actual query
#' plan ran by Polars is shown by `describe_optimized_plan()`. Note that the
#' queries are read from bottom to top.
#'
#' @param .data A Polars LazyFrame
#' @export
#' @examples
#' query <- mtcars |>
#'   as_polars(lazy = TRUE) |>
#'   arrange(drat) |>
#'   filter(cyl == 3) |>
#'   select(mpg)
#'
#' describe_plan(query)
#'
#' describe_optimized_plan(query)

# nocov start
describe_plan <- function(.data) {
  if (!inherits(.data, "LazyFrame")) {
    rlang::abort("`describe_plan()` only works on a LazyFrame.")
  }
  .data$describe_plan()
}

#' @export
#' @rdname describe_plan

describe_optimized_plan <- function(.data) {
  if (!inherits(.data, "LazyFrame")) {
    rlang::abort("`describe_optimized_plan()` only works on a LazyFrame.")
  }
  .data$describe_optimized_plan()
}
# nocov end
