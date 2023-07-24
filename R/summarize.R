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
  if (!inherits(.data, "GroupBy")) {
    stop("`pl_summarize()` only works on grouped data.")
  }
  check_polars_data(.data)

  dots <- get_dots(...)
  out_expr <- build_polars_expr(.data, dots)

  out <- out_expr$out_expr |>
    str2lang() |>
    eval()

  if (length(out_expr$to_drop) > 0) {
    out$drop(out_expr$to_drop)
  } else {
    out
  }
}

#' @rdname pl_summarize
#' @export
pl_summarise <- pl_summarize

build_polars_expr <- function(.data, dots) {
  out_exprs <- rearrange_exprs(.data, dots)
  to_drop <- names(out_exprs[[1]])

  out_exprs <- Filter(Negate(is.null), out_exprs[[2]])
  out_exprs <- unlist(out_exprs)
  out_exprs <- paste(out_exprs, collapse = ", ")

  # deal with groups
  grps <- paste0("'", pl_groups(.data), "'")
  mo <- attributes(.data)$private$maintain_order
  grps <- paste(grps, collapse = ", ")

  out_expr <- paste0(".data$agg(", out_exprs, ")")
  if (length(grps) > 1 || (length(grps) == 1 & grps != "''")) {
    out_expr <- paste0(
      out_expr, "$groupby(", grps, ", maintain_order = ", mo, ")"
    )
  }

  return(
    list(
      out_expr = out_expr,
      to_drop = to_drop
    )
  )

}
