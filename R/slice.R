#' Subset the first or last rows of a Data/LazyFrame
#'
#' @param .data A Polars Data/LazyFrame
#' @param n The number of rows to select from the start or the end of the data.
#'
#' @rdname pl_slice
#' @export
#' @examples
#' pl_test <- polars::pl$DataFrame(iris)
#' pl_slice_head(pl_test, 3)
#' pl_slice_tail(pl_test, 3)

pl_slice_tail <- function(.data, n = 5) {
  check_polars_data(.data)
  grps <- attributes(.data)$pl_grps
  is_grouped <- !is.null(grps)

  if (is_grouped) {
    non_grps <- setdiff(pl_colnames(.data), grps)
    .data$groupby(grps)$agg(
      pl$all()$tail(n)
    )$explode(non_grps)
  } else {
    .data$tail(n)
  }
}

#' @rdname pl_slice
#' @export
pl_slice_head <- function(.data, n = 5) {
  check_polars_data(.data)
  grps <- attributes(.data)$pl_grps
  is_grouped <- !is.null(grps)

  if (is_grouped) {
    non_grps <- setdiff(pl_colnames(.data), grps)
    .data$groupby(grps)$agg(
      pl$all()$head(n)
    )$explode(non_grps)
  } else {
    .data$head(n)
  }
}
