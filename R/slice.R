#' Subset rows of a Data/LazyFrame
#'
#' @param .data A Polars Data/LazyFrame
#' @param n The number of rows to select from the start or the end of the data.
#' Cannot be used with `prop`.
#' @param ... Not used.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_test <- polars::pl$DataFrame(iris)
#' slice_head(pl_test, n = 3)
#' slice_tail(pl_test, n = 3)
#' slice_sample(pl_test, n = 5)
#' slice_sample(pl_test, prop = 0.1)

slice_tail.DataFrame <- function(.data, ..., n) {
  check_polars_data(.data)
  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  if (is_grouped) {
    non_grps <- setdiff(pl_colnames(.data), grps)
    .data$group_by(grps, maintain_order = mo)$agg(
      pl$all()$tail(n)
    )$explode(non_grps)
  } else {
    .data$tail(n)
  }
}

#' @export
slice_tail.LazyFrame <- slice_tail.DataFrame

#' @rdname slice_tail.DataFrame
#' @export

slice_head.DataFrame <- function(.data, ..., n) {
  check_polars_data(.data)
  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  if (is_grouped) {
    non_grps <- setdiff(pl_colnames(.data), grps)
    .data$group_by(grps, maintain_order = mo)$agg(
      pl$all()$head(n)
    )$explode(non_grps)
  } else {
    .data$head(n)
  }
}

#' @export
slice_head.LazyFrame <- slice_head.DataFrame


#' @param prop Proportion of rows to select. Cannot be used with `n`.
#' @param replace Perform the sampling with replacement (`TRUE`) or without
#' (`FALSE`).
#'
#' @rdname slice_tail.DataFrame
#' @export

slice_sample.DataFrame <- function(.data, ..., n = NULL, prop = NULL, replace = FALSE) {
  check_polars_data(.data)

  if (inherits(.data, "LazyFrame")) {
    abort("`slice_sample()` only works on Polars DataFrames.")
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
    .data$group_by(grps, maintain_order = mo)$agg(
      pl$all()$sample(n = n, frac = prop, with_replacement = replace)
    )$explode(non_grps)
  } else {
    .data$sample(n = n, frac = prop, with_replacement = replace)
  }
}
