#' Convert an R dataframe to a Polars Data/LazyFrame
#'
#' This operation is time- and memory-consuming. It should only be used for small
#' datasets. Use `polars` original functions to read files instead.
#'
#' @param .data An R dataframe.
#' @param lazy Convert the data to lazy format.
#' @param with_string_cache Enable the string cache globally. This allows more
#' operations, such as comparing factors to strings but may cost some performance.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' mtcars |>
#'   as_polars()
#' mtcars |>
#'   as_polars(lazy = TRUE)

# nocov start
as_polars <- function(.data, lazy = FALSE, with_string_cache = FALSE) {

  if (isTRUE(with_string_cache)) {
    if (polars::pl$using_string_cache()) {
      rlang::inform("String cache is already globally enabled.")
    } else {
      polars::pl$enable_string_cache()
    }
  }

  if (isTRUE(lazy)) {
    pl$LazyFrame(.data)
  } else {
    pl$DataFrame(.data)
  }
}
# nocov end
