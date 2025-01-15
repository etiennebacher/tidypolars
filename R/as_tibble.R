#' Convert a Polars DataFrame to an R data.frame or to a tibble
#'
#' This makes it easier to convert a polars [DataFrame][DataFrame_class] or
#' [LazyFrame][LazyFrame_class] to a [`tibble`][tibble::tibble] in a pipe
#' workflow.
#'
#' @inheritParams count.RPolarsDataFrame
#' @param int64_conversion How should Int64 values be handled when converting a
#'   polars object to R? See the documentation in
#'   [`polars::as.data.frame.RPolarsDataFrame`].
#' @param ... Options passed to [`polars::as.data.frame.RPolarsDataFrame`].
#'
#' @section About int64: Int64 is a format accepted in Polars but not natively
#'   in R (the package `bit64` helps with that).
#'
#'   Since `tidypolars` is simply a wrapper around `polars`, the behavior of
#'   `int64` values will depend on the options set in `polars`. Use
#'   `options(polars.int64_conversion =)` to specify how int64 variables should
#'   be handled. See the [documentation in
#'   `polars`](https://pola-rs.github.io/r-polars/man/polars_options.html) for
#'   the possible options.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE)
#' iris |>
#'   as_polars_df() |>
#'   filter(Sepal.Length > 6) |>
#'   as_tibble()
as_tibble.tidypolars <- function(
  x,
  int64_conversion = polars::polars_options()$int64_conversion,
  ...
) {
  dplyr::as_tibble(as.data.frame(x, int64_conversion = int64_conversion, ...))
}

#' @export
as_tibble.RPolarsDataFrame <- as_tibble.tidypolars

#' @export
as_tibble.RPolarsLazyFrame <- as_tibble.tidypolars
