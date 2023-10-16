#' Complete a data frame with missing combinations of data
#'
#' Turns implicit missing values into explicit missing values. This is useful
#' for completing missing combinations of data. Note that this function doesn't
#' work with grouped data yet.
#'
#' @param .data A Polars Data/LazyFrame
#' @inheritParams pl_select
#' @param fill A named list that for each variable supplies a single value to
#' use instead of `NA` for missing combinations.
#'
#' @export
#' @examples
#' df <- polars::pl$DataFrame(
#'   group = c(1:2, 1, 2),
#'   item_id = c(1:2, 2, 3),
#'   item_name = c("a", "a", "b", "b"),
#'   value1 = c(1, NA, 3, 4),
#'   value2 = 4:7
#' )
#' df
#'
#' df |> pl_complete(group, item_id, item_name)
#'
#' df |>
#'   pl_complete(
#'     group, item_id, item_name,
#'     fill = list(value1 = 0, value2 = 99)
#'   )

pl_complete <- function(.data, ..., fill = list()) {

  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  if (length(vars) < 2) return(.data)

  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  # TODO: implement by group
  # df |>
  #  pl_group_by(group) |>
  #  pl_complete(item_id, item_name)
  # foo <- df$group_by(grps)$agg(pl$col(vars)$unique()$sort()$implode())
  # need to explode twice in this case

  chain <- .data$select(pl$col(vars)$unique()$sort()$implode())
  for (i in 1:length(vars)) {
    chain <- chain$explode(vars[i])
  }
  out <- chain$join(.data, on = vars, how = 'left')

  # TODO: implement argument `explicit`
  if (length(fill) > 0) {
    out <- pl_replace_na(out, fill)
  }

  if (isTRUE(is_grouped)) {
    out |>
      pl_relocate(tidyselect::all_of(grps), .before = 1) |>
      pl_group_by(tidyselect::all_of(grps))
  } else {
    out
  }

}
