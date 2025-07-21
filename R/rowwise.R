#' Group input by rows
#'
#' @description
#' \[EXPERIMENTAL\]
#'
#' `rowwise()` allows you to compute on a Data/LazyFrame a row-at-a-time. This
#' is most useful when a vectorised function doesn't exist. `rowwise()` produces
#' another type of grouped data, and therefore can be removed with `ungroup()`.
#'
#' @inheritParams drop_na.RPolarsDataFrame
#'
#' @export
#' @return A Polars Data/LazyFrame.
#' @examplesIf require("dplyr", quietly = TRUE)
#' df <- polars0::pl$DataFrame(x = c(1, 3, 4), y = c(2, 1, 5), z = c(2, 3, 1))
#'
#' # Compute the mean of x, y, z in each row
#' df |>
#'  rowwise() |>
#'  mutate(m = mean(c(x, y, z)))
#'
#' # Compute the min and max of x and y in each row
#' df |>
#'  rowwise() |>
#'  mutate(min = min(c(x, y)), max = max(c(x, y)))
rowwise.RPolarsDataFrame <- function(data, ...) {
  if (!is.null(attributes(data)$pl_grps)) {
    cli_abort("Cannot use {.fn rowwise} on grouped data.")
  }

  vars <- tidyselect_dots(data, ...)
  # need to clone, otherwise the data gets attributes, even if unassigned
  data2 <- data$clone()
  if (length(vars) > 0) {
    attr(data2, "pl_grps") <- vars
  }
  attr(data2, "grp_type") <- "rowwise"
  add_tidypolars_class(data2)
}

#' @rdname rowwise.RPolarsDataFrame
#' @export
rowwise.RPolarsLazyFrame <- rowwise.RPolarsDataFrame
