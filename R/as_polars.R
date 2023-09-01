#' Convert an R dataframe to a Polars Data/LazyFrame
#'
#' This operation is time- and memory-consuming. It should only be used for small
#' datasets. Use `polars` original functions to read files instead.
#'
#' @param .data An R dataframe.
#' @param lazy Convert the data to lazy format.
#' @param with_string_cache Enable the string cache. This allows more operations,
#' such as comparing factors to strings but may cost some performance.
#'
#' @export
#' @examples
#' mtcars |>
#'   as_polars()
#' mtcars |>
#'   as_polars(lazy = TRUE)

# nocov start
as_polars <- function(.data, lazy = FALSE, with_string_cache = FALSE) {

  # TODO: in r-polars, add string cache in pl$get_polars_options() so that I
  # can know if it's already globally enabled

  # can't disable it here because I can't still use filter() after that
  # NOT GOOD: enabling it for one Data/lazyFrame will quietly enable it globally
  # if (isTRUE(with_string_cache)) {
  #   polars::pl$enable_string_cache(TRUE)
  #   # on.exit(polars::pl$enable_string_cache(FALSE))
  # }

  if (isTRUE(with_string_cache)) {
    inform(
      paste(
        "This argument does nothing for now.",
        "Please use `polars::pl$enable_string_cache(TRUE)` instead."
      )
    )
  }

  if (isTRUE(lazy)) {
    pl$LazyFrame(.data)
  } else {
    pl$DataFrame(.data)
  }
}
# nocov end
