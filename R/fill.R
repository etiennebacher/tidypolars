#' Fill in missing values with previous or next value
#'
#' Fills missing values in selected columns using the next or previous entry.
#' This is useful in the common output format where values are not repeated, and
#' are only recorded when they change.
#'
#' With grouped Data/LazyFrames, pl_fill() will be applied within each group,
#' meaning that it won't fill across group boundaries.
#'
#' @param data A Polars Data/LazyFrame
#' @inheritParams pl_select
#' @param direction Direction in which to fill missing values. Either "down"
#'    (the default), "up", "downup" (i.e. first down and then up) or "updown"
#'    (first up and then down).
#'
#' @export
#' @examples
#' pl_test <- polars::pl$DataFrame(x = c(NA, 1), y = c(2, NA))
#'
#' pl_fill(pl_test, everything(), direction = "down")
#' pl_fill(pl_test, everything(), direction = "up")
#'
#' # with grouped data, it doesn't use values from other groups
#' pl_grouped <- polars::pl$DataFrame(
#'   grp = rep(c("A", "B"), each = 3),
#'   x = c(1, NA, NA, NA, 2, NA),
#'   y = c(3, NA, 4, NA, 3, 1)
#' ) |>
#'   pl_group_by(grp)
#'
#' pl_fill(pl_grouped, x, y, direction = "down")

pl_fill <- function(data, ..., direction = c("down", "up", "downup", "updown")) {

  check_polars_data(data)
  vars <- .select_nse_from_dots(data, ...)
  direction <- match.arg(direction)

  expr <- paste0("pl$col('", vars, "')$")
  expr_fill <- switch(
    direction,
    "down" = "fill_null(strategy = 'forward')",
    "up" = "fill_null(strategy = 'backward')",
    "downup" = "fill_null(strategy = 'forward')$fill_null(strategy = 'backward')",
    "updown" = "fill_null(strategy = 'backward')$fill_null(strategy = 'forward')"
  )

  # the code for grouped data uses $over() inside $with_columns(), which
  # cannot be used with grouped data. Therefore I have to manually ungroup
  # the data
  # TODO: this is not finished, see TODO in the test_fill
  if (inherits(data, "GroupBy") | inherits(data, "GroupBy")) {
    grps <- attributes(data)$pl_grps
    if (inherits(data, "GroupBy")) {
      attributes(data)$class <- "DataFrame"
    } else {
      attributes(data)$class <- "LazyFrame"
    }
    expr_fill <- paste0(expr_fill, "$over(grps)")
  }

  expr <- paste0(expr, expr_fill)
  final_expr <- paste(expr, collapse = ",")

  paste0("data$with_columns(", final_expr, ")") |>
    str2lang() |>
    eval()
}
