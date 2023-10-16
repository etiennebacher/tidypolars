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
  mo <- attributes(.data)$maintain_grp_order
  if (is.null(mo)) mo <- FALSE
  is_grouped <- !is.null(grps)

  if (!is_grouped) {
    rlang::abort("`pl_summarize()` only works on grouped data.")
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

#' @rdname pl_summarize
#' @export
pl_summarise <- pl_summarize
