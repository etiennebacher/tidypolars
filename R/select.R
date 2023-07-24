#' Select columns from a Data/LazyFrame
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Any expression accepted by `dplyr::select()`: variable names,
#'  column numbers, select helpers, etc.
#'
#' @export
#' @examples
#'
#' pl_iris <- polars::pl$DataFrame(iris)
#'
#' pl_select(pl_iris, c("Sepal.Length", "Sepal.Width"))
#' pl_select(pl_iris, Sepal.Length, Sepal.Width)
#' pl_select(pl_iris, 1:3)
#' pl_select(pl_iris, starts_with("Sepal"))
#' pl_select(pl_iris, -ends_with("Length"))

pl_select <- function(.data, ...) {
  check_polars_data(.data)
  vars <- .select_nse_from_dots(.data, ...)
  .data$select(vars)
}
