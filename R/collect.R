#' Collect a LazyFrame
#'
#' Polars LazyFrames are not loaded in memory. Running `collect()` checks the
#' execution plan, optimizes it in the background and performs it. The result
#' is loaded in the R session.
#'
#' @param .data A Polars LazyFrame
#'
#' @export
#' @examples
#' dat_lazy <- polars::pl$DataFrame(iris)$lazy()
#' pl_collect(dat_lazy)

pl_collect <- function(.data) {
  if (!inherits(.data, "LazyFrame")) {
    stop("`collect()` can only be used on a LazyFrame.")
  }
  .data$collect()
}
