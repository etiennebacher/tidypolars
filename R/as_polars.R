#' Convert an R dataframe to a Polars Data/LazyFrame
#'
#' This operation is time- and memory-consuming. It should only be used for small
#' datasets. Use `polars` original functions to read files instead.
#'
#' @param .data An R dataframe.
#' @param lazy Convert the data to lazy format.
#'
#' @export
#' @examples
#' mtcars |>
#'   as_polars()

as_polars <- function(.data, lazy = FALSE) {
  if (isTRUE(lazy)) {
    pl$DataFrame(.data)$lazy()
  } else {
    pl$DataFrame(.data)
  }
}
