#' Extract a variable of a Data/LazyFrame
#'
#' This returns an R vector and not a Polars Series.
#'
#' @param .data A Polars Data/LazyFrame
#' @param var A quoted or unquoted variable name
#'
#' @export
#' @examples
#' pl_test <- polars::pl$DataFrame(iris)
#' pl_pull(pl_test, Sepal.Length)
#' pl_pull(pl_test, "Sepal.Length")

pl_pull <- function(.data, var) {
  check_polars_data(.data)
  var <- tidyselect_named_arg(.data, rlang::enquo(var))
  # for testing only
  if (inherits(.data, "LazyFrame") && Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
    return(.data$collect()$select(pl$col(var))$to_series()$to_r())
  }

  .data$select(pl$col(var))$to_series()$to_r()
}

