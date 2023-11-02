#' Remove or keep only duplicated rows in a Data/LazyFrame
#'
#' By default, duplicates are looked for in all variables. It is possible to
#' specify a subset of variables where duplicates should be looked for. It is
#' also possible to keep either the first occurrence, the last occurence or
#' remove all duplicates.
#'
#' @inheritParams select.DataFrame
#' @param keep Either "first" (keep the first occurrence of the duplicated row),
#'  "last" (last occurrence) or "none" (remove all ofccurences of duplicated
#'  rows).
#' @param maintain_order Maintain row order. This is the default but it can
#'  slow down the process with large datasets and it prevents the use of
#'  streaming.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_test <- polars::pl$DataFrame(
#'   iso_o = c(rep(c("AA", "AB"), each = 2), "AC", "DC"),
#'   iso_d = rep(c("BA", "BB", "BC"), each = 2),
#'   value = c(2, 2, 3, 4, 5, 6)
#' )
#'
#' distinct(pl_test)
#' distinct(pl_test, iso_o)
#'
#' duplicated_rows(pl_test)
#' duplicated_rows(pl_test, iso_o, iso_d)

distinct.DataFrame <- function(.data, ..., keep = "first", maintain_order = TRUE) {
  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  if (length(vars) == 0) vars <- pl_colnames(.data)
  .data$unique(subset = vars, keep = keep, maintain_order = maintain_order)
}

#' @export
distinct.LazyFrame <- distinct.DataFrame

#' @rdname distinct.DataFrame
#' @export

duplicated_rows <- function(.data, ...) {
  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  if (length(vars) == 0) vars <- pl_colnames(.data)
  .data$filter(pl$struct(vars)$is_duplicated())
}
