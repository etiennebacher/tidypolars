#' Fill in missing values with previous or next value
#'
#' Fills missing values in selected columns using the next or previous entry.
#' This is useful in the common output format where values are not repeated, and
#' are only recorded when they change.
#'
#' With grouped Data/LazyFrames, fill() will be applied within each group,
#' meaning that it won't fill across group boundaries.
#'
#' @param data A Polars Data/LazyFrame
#' @param ... Any expression accepted by `dplyr::select()`: variable names,
#'  column numbers, select helpers, etc.
#' @param .direction Direction in which to fill missing values. Either "down"
#'    (the default), "up", "downup" (i.e. first down and then up) or "updown"
#'    (first up and then down).
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_test <- polars::pl$DataFrame(x = c(NA, 1), y = c(2, NA))
#'
#' fill(pl_test, everything(), .direction = "down")
#' fill(pl_test, everything(), .direction = "up")
#'
#' # with grouped data, it doesn't use values from other groups
#' pl_grouped <- polars::pl$DataFrame(
#'   grp = rep(c("A", "B"), each = 3),
#'   x = c(1, NA, NA, NA, 2, NA),
#'   y = c(3, NA, 4, NA, 3, 1)
#' ) |>
#'   group_by(grp)
#'
#' fill(pl_grouped, x, y, .direction = "down")

fill.RPolarsDataFrame <- function(
  data,
  ...,
  .direction = c("down", "up", "downup", "updown")
) {
  vars <- tidyselect_dots(data, ...)
  if (length(vars) == 0) {
    return(data)
  }
  .direction <- match.arg(.direction)

  grps <- attributes(data)$pl_grps
  is_grouped <- !is.null(grps)
  mo <- attributes(data)$maintain_grp_order

  expr <- polars::pl$col(vars)
  expr <- switch(
    .direction,
    "down" = expr$fill_null(strategy = 'forward'),
    "up" = expr$fill_null(strategy = 'backward'),
    "downup" = expr$fill_null(strategy = 'forward')$fill_null(
      strategy = 'backward'
    ),
    "updown" = expr$fill_null(strategy = 'backward')$fill_null(
      strategy = 'forward'
    )
  )

  if (is_grouped) {
    expr <- expr$over(grps)
  }

  out <- if (is_grouped) {
    data$with_columns(expr) |>
      group_by(all_of(grps), maintain_order = mo)
  } else {
    data$with_columns(expr)
  }

  add_tidypolars_class(out)
}

#' @export
fill.RPolarsLazyFrame <- fill.RPolarsDataFrame
