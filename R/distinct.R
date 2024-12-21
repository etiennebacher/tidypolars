#' Remove or keep only duplicated rows in a Data/LazyFrame
#'
#' By default, duplicates are looked for in all variables. It is possible to
#' specify a subset of variables where duplicates should be looked for. It is
#' also possible to keep either the first occurrence, the last occurence or
#' remove all duplicates.
#'
#' @inheritParams complete.RPolarsDataFrame
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

distinct.RPolarsDataFrame <- function(
	.data,
	...,
	keep = "first",
	maintain_order = TRUE
) {
	vars <- tidyselect_dots(.data, ...)
	if (length(vars) == 0) vars <- names(.data)
	out <- .data$unique(
		subset = vars,
		keep = keep,
		maintain_order = maintain_order
	)
	add_tidypolars_class(out)
}

#' @rdname distinct.RPolarsDataFrame
#' @export
distinct.RPolarsLazyFrame <- distinct.RPolarsDataFrame

#' @rdname distinct.RPolarsDataFrame
#' @export

duplicated_rows <- function(.data, ...) {
	vars <- tidyselect_dots(.data, ...)
	if (length(vars) == 0) vars <- names(.data)
	out <- .data$filter(pl$struct(vars)$is_duplicated())
	add_tidypolars_class(out)
}
