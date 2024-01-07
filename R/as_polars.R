#' Convert an R dataframe to a Polars Data/LazyFrame
#'
#' \[DEPRECATED\]
#' This operation is time- and memory-consuming. It should only be used for small
#' datasets. Use `polars` original functions to read files instead.
#'
#' @param .data An R dataframe.
#' @param lazy Convert the data to lazy format.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' # this function is deprecated, use as_polars_lf() or as_polars_df() instead
#' mtcars |>
#'   as_polars_df()
#' mtcars |>
#'   as_polars_lf()

# nocov start
as_polars <- function(.data, lazy = FALSE) {
  if (isTRUE(lazy)) {
    rlang::warn(
      c(
        "x" = "`as_polars(..., lazy = TRUE)` is deprecated and will be removed in tidypolars 0.7.0.",
        "i" = "Please use `as_polars_lf()` instead."
      )
    )
    pl$LazyFrame(.data)
  } else {
    rlang::warn(
      c(
        "x" = "`as_polars(...)` is deprecated and will be removed in tidypolars 0.7.0.",
        "i" = "Please use `as_polars_df()` instead."
      )
    )
    pl$DataFrame(.data)
  }
}
# nocov end
