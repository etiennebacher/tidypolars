#' Replace NAs with specified values
#'
#' @param data A Polars Data/LazyFrame
#' @param replace Either a scalar that will be used to replace `NA` in all
#'   columns, or a named list with the column name and the value that will be
#'   used to replace `NA` in it.
#' @inheritParams slice_tail.RPolarsDataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_test <- polars::pl$DataFrame(x = c(NA, 1), y = c(2, NA))
#'
#' # replace all NA with 0
#' replace_na(pl_test, 0)
#'
#' # custom replacement per column
#' replace_na(pl_test, list(x = 0, y = 999))

replace_na.RPolarsDataFrame <- function(data, replace, ...) {

  data <- check_polars_data(data)
  is_scalar <- length(replace) == 1 && !is.list(replace)

  # TODO: maybe re-use fill_null() once this is fixed
  # https://github.com/pola-rs/polars/issues/13789
  #
  # replace() errors if we try to replace numeric by character, but coerces
  # floats to integer.
  # fill_null() does the opposite
  #
  # => depending on the replacement, use one or the other.
  if (is_scalar) {
    if (is.character(replace)) {
      exprs <- pl$all()$replace(NA, replace)
    } else {
      exprs <- pl$all()$fill_null(replace)
    }
  } else if (is.list(replace)) {
    exprs <- list()
    for (i in seq_along(replace)) {
      if (is.character(replace[[i]])) {
        exprs[[i]] <- polars::pl$col(names(replace)[i])$replace(NA, replace[[i]])
      } else {
        exprs[[i]] <- polars::pl$col(names(replace)[i])$fill_null(replace[[i]])
      }
    }
  }

  out
}

#' @rdname replace_na.RPolarsDataFrame
#' @export
replace_na.RPolarsLazyFrame <- replace_na.RPolarsDataFrame
