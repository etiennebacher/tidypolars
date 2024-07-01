#' Uncount a Data/LazyFrame
#'
#' This duplicates rows according to a weighting variable (or expression). This
#' is the opposite of `count()`.
#'
#' @param data A Polars Data/LazyFrame
#' @param weights A vector of weights. Evaluated in the context of `data`.
#' @param ... Not used.
#' @param .remove If `TRUE`, and weights is the name of a column in data, then
#' this column is removed.
#' @param .id Supply a string to create a new variable which gives a unique
#' identifier for each created row.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars::pl$DataFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))
#' test
#'
#' uncount(test, n)
#'
#' uncount(test, n, .id = "id")
#'
#' # using constants
#' uncount(test, 2)
#'
#' # using expressions
#' uncount(test, 2 / n)

uncount.RPolarsDataFrame <- function(data, weights, ..., .remove = TRUE, .id = NULL) {

  weights_quo <- enquo(weights)
  repeat_expr <- translate_expr(data, weights_quo, new_vars = NULL, env = rlang::current_env())

  out <- data$with_columns(pl$col("x")$repeat_by(repeat_expr))$explode(pl$col("x"))

  if (isTRUE(.remove) && repeat_expr$meta$output_name() != "literal") {
    out <- out$drop(repeat_expr$meta$output_name())
  }

  if (!is.null(.id)) {
    out <- out$with_columns((pl$col(names(out)[1])$cum_count()$over(names(out)))$alias(.id))
  }

  add_tidypolars_class(out)
}

#' @rdname uncount.RPolarsDataFrame
#' @export
uncount.RPolarsLazyFrame <- uncount.RPolarsDataFrame
