#' Remove duplicated rows in a Data/LazyFrame
#'
#' By default, duplicates are looked for in all variables. It is possible to
#' specify a subset of variables where duplicates should be looked for. It is
#' also possible to keep either the first occurrence, the last occurence or
#' remove all duplicates.
#'
#' @inheritParams pl_select
#' @param keep Either "first" (keep the first occurrence of the duplicated row),
#'  "last" (last occurrence) or "none" (remove all ofccurences of duplicated
#'  rows).
#' @param maintain_order Maintain row order. This is the default but it can
#'  slow down the process with large datasets and it prevents the use of
#'  streaming.
#'
#' @export
#' @examples
#' pl_test <- polars::pl$DataFrame(
#'   iso_o = rep(c("AA", "AB", "AC"), each = 2),
#'   iso_d = rep(c("BA", "BB", "BC"), each = 2),
#'   value = 1:6
#' )
#'
#' pl_distinct(pl_test)
#' pl_distinct(pl_test, iso_o)

pl_distinct <- function(.data, ..., keep = "first", maintain_order = TRUE) {
  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  if (length(vars) == 0) vars <- pl_colnames(.data)
  .data$unique(subset = vars, keep = keep, maintain_order = maintain_order)
}

