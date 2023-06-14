#' @export

pl_mutate <- function(data, ...) {

  check_polars_data(data)

  dots <- get_dots(...)
  out_exprs <- rearrange_exprs(data, dots)

  out_exprs <- unlist(out_exprs)
  out_exprs <- paste(out_exprs, collapse = ", ")

  if (inherits(data, "GroupBy") || inherits(data, "LazyGroupBy")) {
    grps <- deparse(paste(pl_groups(data), collapse = ", "))
    if (inherits(data, "GroupBy")) {
      class(data) <- "DataFrame"
    } else if (inherits(data, "LazyGroupBy")) {
      class(data) <- "LazyFrame"
    }

    out_exprs <- paste0(out_exprs, "$over(", eval(grps), ")")
    out <- paste0("data$with_columns(", out_exprs, ")$groupby(", eval(grps), ")")
  } else {
    out <- paste0("data$with_columns(", out_exprs, ")")
  }

  out |>
    str2lang() |>
    eval()
}
