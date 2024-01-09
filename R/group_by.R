#' Group by one or more variables
#'
#' Most data operations are done on groups defined by variables. `group_by()`
#' takes an existing Polars Data/LazyFrame and converts it into a grouped one
#' where operations are performed "by group". `ungroup()` removes grouping.
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Variables to group by (used in `group_by()` only). Not used in
#' `ungroup()`.
#' @param maintain_order Maintain row order. For performance reasons, this is
#' `FALSE` by default). Setting it to `TRUE` can slow down the process with
#' large datasets and prevents the use of streaming.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' by_cyl <- mtcars |>
#'   as_polars_df() |>
#'   group_by(cyl)
#'
#' by_cyl
#'
#' by_cyl |> summarise(
#'   disp = mean(disp),
#'   hp = mean(hp)
#' )
#' by_cyl |> filter(disp == max(disp))
#'

group_by.RPolarsDataFrame <- function(.data, ..., maintain_order = FALSE) {
  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  # need to clone, otherwise the data gets attributes, even if unassigned
  .data2 <- .data$clone()
  attr(.data2, "pl_grps") <- vars
  attr(.data2, "maintain_grp_order") <- maintain_order
  .data2
}

#' @param x A Polars Data/LazyFrame
#' @rdname group_by.RPolarsDataFrame
#' @export

ungroup.RPolarsDataFrame <- function(x, ...) {
  attributes(x)$pl_grps <- NULL
  attributes(x)$maintain_grp_order <- NULL
  x
}

#' @rdname group_by.RPolarsDataFrame
#' @export
group_by.RPolarsLazyFrame <- group_by.RPolarsDataFrame

#' @rdname group_by.RPolarsDataFrame
#' @export
ungroup.RPolarsLazyFrame <- ungroup.RPolarsDataFrame
