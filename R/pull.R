#' Extract a variable of a Data/LazyFrame
#'
#' This returns an R vector and not a Polars Series.
#'
#' @param .data A Polars Data/LazyFrame
#' @param var A quoted or unquoted variable name, or a variable index.
#' @inheritParams slice_tail.polars_data_frame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE)
#' pl_test <- as_polars_df(iris)
#' pull(pl_test, Sepal.Length)
#' pull(pl_test, "Sepal.Length")

pull.polars_data_frame <- function(.data, var, ...) {
  var <- tidyselect_named_arg(.data, rlang::enquo(var))
  if (length(var) > 1) {
    cli_abort(
      "{.fn pull} can only extract one column. You tried to extract {length(var)}."
    )
  }

  out <- add_tidypolars_class(.data)
  if (is_polars_lf(.data)) {
    out <- out$collect()
  }
  as.data.frame(out$select(pl$col(var)))[[1]]
}

#' @rdname pull.polars_data_frame
#' @export
pull.polars_lazy_frame <- pull.polars_data_frame
