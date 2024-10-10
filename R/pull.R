#' Extract a variable of a Data/LazyFrame
#'
#' This returns an R vector and not a Polars Series.
#'
#' @param .data A Polars Data/LazyFrame
#' @param var A quoted or unquoted variable name, or a variable index.
#' @inheritParams slice_tail.RPolarsDataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE)
#' pl_test <- as_polars_df(iris)
#' pull(pl_test, Sepal.Length)
#' pull(pl_test, "Sepal.Length")
pull.RPolarsDataFrame <- function(.data, var, ...) {
  var <- tidyselect_named_arg(.data, rlang::enquo(var))
  if (length(var) > 1) {
    rlang::abort(
      paste0("`pull` can only extract one column. You tried to extract ", length(var), ".")
    )
  }

  out <- add_tidypolars_class(.data)
  if (inherits(.data, "RPolarsLazyFrame")) {
    out <- out$collect()
  }
  as.data.frame(out$select(pl$col(var)))[[1]]
}

#' @rdname pull.RPolarsDataFrame
#' @export
pull.RPolarsLazyFrame <- pull.RPolarsDataFrame
