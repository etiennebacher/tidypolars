#' Complete a data frame with missing combinations of data
#'
#' Turns implicit missing values into explicit missing values. This is useful
#' for completing missing combinations of data. Note that this function doesn't
#' work with grouped data yet.
#'
#' @param .data A Polars Data/LazyFrame
#' @inheritParams pl_select
#'
#' @export
#' @examples
#' test <- polars::pl$DataFrame(
#'   country = c("France", "France", "UK", "UK", "Spain"),
#'   year = c(2020, 2021, 2019, 2020, 2022),
#'   value = c(1, 2, 3, 4, 5)
#' )
#' test
#'
#' pl_complete(test, country, year)

pl_complete <- function(.data, ...) {

  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  if (length(vars) < 2) return(.data)

  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  chain <- .data$select(pl$col(vars)$unique()$sort()$implode())
  for (i in 1:length(vars)) {
    chain <- chain$explode(vars[i])
  }
  out <- chain$join(.data, on = vars, how = 'left')

  if (isTRUE(is_grouped)) {
    out |>
      pl_relocate(tidyselect::all_of(grps), .before = 1) |>
      pl_group_by(tidyselect::all_of(grps))
  } else {
    out
  }

}
