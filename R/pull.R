#' Extract a variable of a Data/LazyFrame
#'
#' This returns an R vector and not a Polars Series.
#'
#' @param .data A Polars Data/LazyFrame
#' @param var A quoted or unquoted variable name, or a variable index.
#' @param name An optional column to use to name the returned vector.
#' @inheritParams slice_tail.polars_data_frame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE)
#' pl_test <- as_polars_df(iris)
#' pull(pl_test, Sepal.Length)
#' pull(pl_test, "Sepal.Length")

pull.polars_data_frame <- function(.data, var = -1, name = NULL, ...) {
  data_names <- names(.data)
  var <- tidyselect::vars_pull(
    data_names,
    !!rlang::enquo(var)
  )

  name_quo <- rlang::enquo(name)
  name <- if (rlang::quo_is_null(name_quo)) {
    NULL
  } else {
    tidyselect::vars_pull(data_names, !!name_quo)
  }

  out <- add_tidypolars_class(.data)
  cols <- unique(c(var, name))
  exprs <- lapply(cols, \(col) pl$col(col))
  out <- out$select(!!!exprs)
  if (is_polars_lf(out)) {
    out <- out$collect()
  }
  out <- as.data.frame(out)

  value <- out[[1]]
  if (!is.null(name)) {
    names(value) <- out[[match(name, cols)]]
  }
  value
}

#' @rdname pull.polars_data_frame
#' @export
pull.polars_lazy_frame <- pull.polars_data_frame
