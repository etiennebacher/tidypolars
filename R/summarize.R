#' Summarize each group down to one row
#'
#' `summarize()` returns one row for each combination of grouping variables
#' (one difference with `dplyr::summarize()` is that `summarize()` only
#' accepts grouped data). It will contain one column for each grouping variable
#' and one column for each of the summary statistics that you have specified.
#'
#' @param .data A Polars Data/LazyFrame
#' @inheritParams mutate.DataFrame
#'
#' @rdname summarize
#' @export
#' @examples
#' mtcars |>
#'   as_polars() |>
#'   group_by(cyl) |>
#'   summarize(gear = mean(gear), gear2 = sd(gear))


summarize.DataFrame <- function(.data, ...) {

  check_polars_data(.data)

  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order
  if (is.null(mo)) mo <- FALSE
  is_grouped <- !is.null(grps)

  if (!is_grouped) {
    rlang::abort("`summarize()` only works on grouped data.")
  }

  polars_exprs <- translate_dots(.data = .data, ..., env = rlang::caller_env())

  for (i in seq_along(polars_exprs)) {
    sub <- polars_exprs[[i]]
    to_drop <- names(empty_elems(sub))
    sub <- compact(sub)

    if (length(sub) > 0) {
      .data <- .data$group_by(grps, maintain_order = mo)$agg(sub)
    }

    if (length(to_drop) > 0) {
      .data <- .data$drop(to_drop)
    }
  }

  .data
}

#' @rdname summarize
#' @export
summarise.DataFrame <- summarize.DataFrame

#' @export
summarize.LazyFrame <- summarize.DataFrame

#' @export
summarise.LazyFrame <- summarize.DataFrame
