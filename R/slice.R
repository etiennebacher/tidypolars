#' Subset rows of a Data/LazyFrame
#'
#' @param .data A Polars Data/LazyFrame
#' @param n The number of rows to select from the start or the end of the data.
#' Cannot be used with `prop`.
#'
#' @rdname pl_slice
#' @export
#' @examples
#' pl_test <- polars::pl$DataFrame(iris)
#' pl_slice_head(pl_test, 3)
#' pl_slice_tail(pl_test, 3)
#' pl_slice_sample(pl_test, n = 5)
#' pl_slice_sample(pl_test, prop = 0.1)

pl_slice_tail <- function(.data, n = 5) {
  check_polars_data(.data)
  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  if (is_grouped) {
    non_grps <- setdiff(pl_colnames(.data), grps)
    .data$groupby(grps, maintain_order = mo)$agg(
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
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  if (is_grouped) {
    non_grps <- setdiff(pl_colnames(.data), grps)
    .data$groupby(grps, maintain_order = mo)$agg(
      pl$all()$head(n)
    )$explode(non_grps)
  } else {
    .data$head(n)
  }
}

#' @param prop Proportion of rows to select. Cannot be used with `n`.
#' @param replace Perform the sampling with replacement (`TRUE`) or without
#' (`FALSE`).
#'
#' @rdname pl_slice
#' @export

pl_slice_sample <- function(.data, n = NULL, prop = NULL, replace = FALSE) {
  check_polars_data(.data)

  if (packageVersion("polars") <= "0.8.1") {
    abort("`pl_slice_sample()` requires polars > 0.8.1. Try to install a more recent version of polars.")
  }

  if (inherits(.data, "LazyFrame")) {
    abort("`pl_slice_sample()` only works on Polars DataFrames.")
  }

  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  # arguments don't have the same name in polars so I check inputs here
  if (!is.null(n) && !is.null(prop)) {
    abort("You must provide either `n` or `prop`, not both.")
  }
  if (is.null(n) && is.null(prop)) {
    n <- 1
  }
  if (isFALSE(replace) &&
      ((!is.null(n) && n > nrow(.data)) ||
       (!is.null(prop) && prop > 1))) {
    abort("Cannot take more rows than the total number of rows when `replace = FALSE`.")
  }

  if (is_grouped) {
    non_grps <- setdiff(pl_colnames(.data), grps)
    .data$groupby(grps, maintain_order = mo)$agg(
      pl$all()$sample(n = n, frac = prop, with_replacement = replace)
    )$explode(non_grps)
  } else {
    .data$sample(n = n, frac = prop, with_replacement = replace)
  }
}
