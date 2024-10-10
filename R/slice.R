#' Subset rows of a Data/LazyFrame
#'
#' @param .data A Polars Data/LazyFrame
#' @param n The number of rows to select from the start or the end of the data.
#' Cannot be used with `prop`.
#' @param by Optionally, a selection of columns to group by for just this
#'   operation, functioning as an alternative to `group_by()`. The group order
#'   is not maintained, use `group_by()` if you want more control over it.
#' @param ... Not used.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_test <- polars::pl$DataFrame(iris)
#' slice_head(pl_test, n = 3)
#' slice_tail(pl_test, n = 3)
#' slice_sample(pl_test, n = 5)
#' slice_sample(pl_test, prop = 0.1)
slice_tail.RPolarsDataFrame <- function(.data, ..., n, by = NULL) {
  grps <- get_grps(.data, rlang::enquo(by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  if (is_grouped) {
    non_grps <- setdiff(names(.data), grps)
    out <- .data$group_by(grps, maintain_order = mo)$agg(
      pl$all()$tail(n)
    )$explode(non_grps)
  } else {
    out <- .data$tail(n)
  }

  out <- if (is_grouped && missing(by)) {
    group_by(out, all_of(grps), maintain_order = mo)
  } else {
    add_tidypolars_class(out)
  }


  add_tidypolars_class(out)
}

#' @rdname slice_tail.RPolarsDataFrame
#' @export
slice_tail.RPolarsLazyFrame <- slice_tail.RPolarsDataFrame

#' @rdname slice_tail.RPolarsDataFrame
#' @export

slice_head.RPolarsDataFrame <- function(.data, ..., n, by = NULL) {
  grps <- get_grps(.data, rlang::enquo(by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  if (is_grouped) {
    non_grps <- setdiff(names(.data), grps)
    out <- .data$group_by(grps, maintain_order = mo)$agg(
      pl$all()$head(n)
    )$explode(non_grps)
  } else {
    out <- .data$head(n)
  }

  out <- if (is_grouped && missing(by)) {
    group_by(out, all_of(grps), maintain_order = mo)
  } else {
    add_tidypolars_class(out)
  }


  add_tidypolars_class(out)
}

#' @rdname slice_tail.RPolarsDataFrame
#' @export
slice_head.RPolarsLazyFrame <- slice_head.RPolarsDataFrame


#' @param prop Proportion of rows to select. Cannot be used with `n`.
#' @param replace Perform the sampling with replacement (`TRUE`) or without
#' (`FALSE`).
#'
#' @rdname slice_tail.RPolarsDataFrame
#' @export

slice_sample.RPolarsDataFrame <- function(.data, ..., n = NULL, prop = NULL, replace = FALSE, by = NULL) {
  grps <- get_grps(.data, rlang::enquo(by), env = rlang::current_env())
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
    non_grps <- setdiff(names(.data), grps)
    out <- .data$group_by(grps, maintain_order = mo)$agg(
      pl$all()$sample(n = n, fraction = prop, with_replacement = replace)
    )$explode(non_grps)
  } else {
    out <- .data$sample(n = n, fraction = prop, with_replacement = replace)
  }

  out <- if (is_grouped && missing(by)) {
    group_by(out, all_of(grps), maintain_order = mo)
  } else {
    add_tidypolars_class(out)
  }


  add_tidypolars_class(out)
}
