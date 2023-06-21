#' Summarize each group down to one row
#'
#' `pl_summarize()` returns one row for each combination of grouping variables
#' (one difference with `dplyr::summarize()` is that `pl_summarize()` only
#' accepts grouped data). It will contain one column for each grouping variable
#' and one column for each of the summary statistics that you have specified.
#'
#' @param data A Polars Data/LazyFrame
#' @inheritParams pl_mutate
#'
#' @export
#' @examples
#' mtcars |>
#'   as_polars() |>
#'   pl_group_by(cyl) |>
#'   pl_summarize(gear = mean(gear), gear2 = sd(gear))


pl_summarize <- function(data, ...) {
  if (!inherits(data, "GroupBy")) {
    stop("`pl_summarize()` only works on grouped data.")
  }
  check_polars_data(data)

  dots <- get_dots(...)
  out_exprs <- rearrange_exprs(data, dots)
  to_drop <- names(out_exprs[[1]])

  out_exprs <- Filter(Negate(is.null), out_exprs[[2]])
  out_exprs <- unlist(out_exprs)
  out_exprs <- paste(out_exprs, collapse = ", ")

  # deal with groups
  grps <- paste0("'", pl_groups(data), "'")
  mo <- attributes(data)$private$maintain_order
  grps <- paste(grps, collapse = ", ")
  out_expr <- paste0("data$agg(", out_exprs, ")$groupby(", grps, ", maintain_order = ", mo, ")")

  out <- out_expr |>
    str2lang() |>
    eval()

  if (length(to_drop) > 0) {
    out$drop(eval(to_drop))
  } else {
    out
  }
}

#' @export
pl_summarise <- pl_summarize

#' @export
summarize.GroupBy <- pl_summarize

#' @export
summarise.GroupBy <- pl_summarize
