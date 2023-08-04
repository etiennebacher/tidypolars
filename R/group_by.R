#' Group by one or more variables
#'
#' Most data operations are done on groups defined by variables. `pl_group_by()`
#' takes an existing Polars Data/LazyFrame and converts it into a grouped one
#' where operations are performed "by group". `pl_ungroup()` removes grouping.
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Variables to group by (used in `pl_group_by()` only).
#' @param maintain_order Maintain row order. For performance reasons, this is
#' `FALSE` by default). Setting it to `TRUE` can slow down the process with
#' large datasets and prevents the use of streaming.
#'
#' @export
#' @examples
#' by_cyl <- mtcars |>
#'   as_polars() |>
#'   pl_group_by(cyl)
#'
#' by_cyl
#'
#' by_cyl |> pl_summarise(
#'   disp = mean(disp),
#'   hp = mean(hp)
#' )
#' by_cyl |> pl_filter(disp == max(disp))
#'

pl_group_by <- function(.data, ..., maintain_order = FALSE) {
  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  # need to clone, otherwise the data gets attributes, even if unassigned
  .data2 <- .data$clone()
  attr(.data2, "pl_grps") <- vars
  attr(.data2, "maintain_grp_order") <- maintain_order
  .data2
}

#' @rdname pl_group_by
#' @export

pl_ungroup <- function(.data) {
  attributes(.data)$pl_grps <- NULL
  attributes(.data)$maintain_grp_order <- NULL
  .data
}
