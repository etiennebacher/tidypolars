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
#' select(pl_iris, c("Sepal.Length", "Sepal.Width"))
#' select(pl_iris, Sepal.Length, Sepal.Width)
#' select(pl_iris, 1:3)
#' select(pl_iris, starts_with("Sepal"))
#' select(pl_iris, -ends_with("Length"))

select.DataFrame <- function(.data, ...) {
  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  .data$select(vars)
}

#' @export
select.LazyFrame <- select.DataFrame
