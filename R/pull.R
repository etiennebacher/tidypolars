#' Extract a variable of a Data/LazyFrame
#'
#' This returns an R vector and not a Polars Series.
#'
#' @param .data A Polars Data/LazyFrame
#' @param var A quoted or unquoted variable name
#' @inheritParams slice_tail.RPolarsDataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_test <- polars::pl$DataFrame(iris)
#' pull(pl_test, Sepal.Length)
#' pull(pl_test, "Sepal.Length")

pull.RPolarsDataFrame <- function(.data, var, ...) {
  check_polars_data(.data)
  var <- tidyselect_named_arg(.data, rlang::enquo(var))
  out <- add_tidypolars_class(.data)
  # for testing only
  if (inherits(.data, "RPolarsLazyFrame") && Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
    out <- out$collect()
  }
  as.data.frame(out$select(pl$col(var)))[[1]]
}

#' @rdname pull.RPolarsDataFrame
#' @export
pull.RPolarsLazyFrame <- pull.RPolarsDataFrame
