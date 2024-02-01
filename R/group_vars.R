#' Grouping metadata
#'
#' `group_vars()` returns a character vector with the names of the grouping
#' variables. `group_keys()` returns a data frame with one row per group.
#'
#' @inheritParams select.RPolarsDataFrame
#'
#' @export
#' @examples
#' pl_g <- polars::as_polars_df(mtcars) |>
#'   group_by(cyl, am)
#'
#' group_vars(pl_g)
#'
#' group_keys(pl_g)
group_vars.RPolarsDataFrame <- function(.data) {
  check_polars_data(.data)
  grps <- attributes(.data)$pl_grps
  if (length(grps) > 0) {
    grps
  } else {
    character(0)
  }
}

#' @rdname group_vars.RPolarsDataFrame
#' @export
group_vars.RPolarsLazyFrame <- group_vars.RPolarsDataFrame

#' @rdname group_vars.RPolarsDataFrame
#' @export
group_keys.RPolarsDataFrame <- function(.data) {
  check_polars_data(.data)
  grps <- attributes(.data)$pl_grps
  if (length(grps) > 0) {
    out = .data$group_by(grps)$
      agg(pl$lit(1))$
      drop("literal")$
      sort(grps)

    if (inherits(out, "RPolarsLazyFrame")) {
      out = out$collect()
    }
    out$to_data_frame()
  } else {
    data.frame()
  }
}

#' @rdname group_vars.RPolarsDataFrame
#' @export
group_keys.RPolarsLazyFrame <- group_keys.RPolarsDataFrame
