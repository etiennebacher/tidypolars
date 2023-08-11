#' Summarize each group down to one row
#'
#' `pl_summarize()` returns one row for each combination of grouping variables
#' (one difference with `dplyr::summarize()` is that `pl_summarize()` only
#' accepts grouped data). It will contain one column for each grouping variable
#' and one column for each of the summary statistics that you have specified.
#'
#' @param .data A Polars Data/LazyFrame
#' @inheritParams pl_mutate
#'
#' @export
#' @examples
#' mtcars |>
#'   as_polars() |>
#'   pl_group_by(cyl) |>
#'   pl_summarize(gear = mean(gear), gear2 = sd(gear))


pl_summarize <- function(.data, ...) {

  check_polars_data(.data)

  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_order
  if (is.null(mo)) mo <- FALSE
  is_grouped <- !is.null(grps)

  if (!is_grouped) {
    rlang::abort("`pl_summarize()` only works on grouped data.")
  }

  polars_exprs <- translate_dots(.data = .data, ...)

  to_drop <- names(Filter(\(x) length(x) == 0, polars_exprs))
  polars_exprs <- Filter(\(x) length(x) != 0, polars_exprs)

  if (length(polars_exprs) > 0) {
    out <- .data$groupby(grps, maintain_order = mo)$agg(polars_exprs)
  } else {
    out <- .data
  }

  if (length(to_drop) > 0) {
    out$drop(to_drop)
  } else {
    out
  }
}

#' @rdname pl_summarize
#' @export
pl_summarise <- pl_summarize
