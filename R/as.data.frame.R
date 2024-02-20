#' Convert a Polars DataFrame to an R data.frame or to a tibble
#'
#' This is a simple wrapper of `$to_data_frame()` present in `polars` that makes
#' it easier to convert a polars [DataFrame][DataFrame_class] to a [`data.frame`] or to a
#' [`tibble`][tibble::tibble] in a pipe workflow.
#'
#' @param x A Polars DataFrame. To convert a LazyFrame, you first need to
#'   explicitly call `collect()`.
#' @param ... Not used.
#'
#' @section About int64: Int64 is a format accepted in Polars but not natively
#'   in R (the package `bit64` helps with that).
#'
#'   Since `tidypolars` is simply a wrapper around `polars`, the behavior of
#'   `int64` values will depend on the options set in `polars`. Use
#'   `options(polars.int64_conversion =)` to specify how int64 variables should
#'   be handled. See the [documentation in
#'   `polars`](https://rpolars.github.io/man/polars_options.html#details) for
#'   the possible options.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' iris |>
#'   as_polars_df() |>
#'   filter(Sepal.Length > 6) |>
#'   as_tibble()
as.data.frame.tidypolars <- function(x, ...) {
  if (inherits(x, "RPolarsLazyFrame")) {
    # for testing only
    if (Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
      return(x$collect()$to_data_frame())
    } else {
      rlang::abort("`as.data.frame()` doesn't work for LazyFrame. Use `collect()` first to convert your LazyFrame to a polars DataFrame.")
    }
  }
  x$to_data_frame()
}

#' @rdname as.data.frame.tidypolars
#' @export
as_tibble.tidypolars <- function(x, ...) {
  if (inherits(x, "RPolarsLazyFrame")) {
    rlang::abort("`as_tibble()` doesn't work for LazyFrame. Use `collect()` first to convert your LazyFrame to a polars DataFrame.")
  }
  dplyr::as_tibble(as.data.frame(x, ...))
}
