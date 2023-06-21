#' @export

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
summarize.DataFrame <- pl_summarize
