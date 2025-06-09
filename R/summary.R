#' Summary statistics for a Polars DataFrame
#'
#' @param object A Polars DataFrame.
#' @param percentiles One or more percentiles to include in the summary
#' statistics. All values must be between 0 and 1 (`NULL` are ignored).
#' @param ... Ignored.
#'
#' @export
#' @examples
#' mtcars |>
#'   as_polars_df() |>
#'   summary(percentiles = c(0.2, 0.4, 0.6, 0.8))

summary.polars_data_frame <- function(
  object,
  percentiles = c(0.25, 0.75),
  ...
) {
  between_zero_one <- percentiles >= 0 & percentiles <= 1
  if (anyNA(between_zero_one) || !all(between_zero_one)) {
    abort("All values of `percentiles` must be between 0 and 1.")
  }
  out <- object$describe(percentiles)
  add_tidypolars_class(out)
}
