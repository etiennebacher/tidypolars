#' @export

pl_mutate <- function(data, ...) {

  check_polars_data(data)

  dots <- get_dots(...)
  out_exprs <- rearrange_exprs(data, dots)
  to_drop <- names(out_exprs[[1]])

  out_exprs <- Filter(Negate(is.null), out_exprs[[2]])
  out_exprs <- unlist(out_exprs)
  out_exprs <- paste(out_exprs, collapse = ", ")

  if (inherits(data, "GroupBy") || inherits(data, "LazyGroupBy")) {
    grps <- paste0("'", pl_groups(data), "'")
    grps <- paste(grps, collapse = ", ")
    if (inherits(data, "GroupBy")) {
      class(data) <- "DataFrame"
    } else if (inherits(data, "LazyGroupBy")) {
      class(data) <- "LazyFrame"
    }

    out_exprs <- paste0(out_exprs, "$over(", eval(grps), ")")
    out_expr <- paste0("data$with_columns(", out_exprs, ")$groupby(", grps, ")")
  } else {
    out_expr <- paste0("data$with_columns(", out_exprs, ")")
  }

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
mutate.DataFrame <- pl_mutate

#' @export
mutate.GroupBy <- pl_mutate
