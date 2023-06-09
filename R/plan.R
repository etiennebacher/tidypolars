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
#'   pl_arrange(drat) |>
#'   pl_filter(cyl == 3) |>
#'   pl_select(mpg)
#'
#' describe_plan(query)
#'
#' describe_optimized_plan(query)

describe_plan <- function(.data) {
  if (!inherits(.data, "LazyFrame")) {
    stop(
      paste("`describe_plan()` only works on a LazyFrame.",
            "The current data is of class ", class(.data))
    )
  }
  .data$describe_plan()
}

#' @export
#' @rdname describe_plan

describe_optimized_plan <- function(.data) {
  if (!inherits(.data, "LazyFrame")) {
    stop(
      paste("`describe_optimized_plan()` only works on a LazyFrame.",
            "The current data is of class ", class(.data))
    )
  }
  .data$describe_optimized_plan()
}
