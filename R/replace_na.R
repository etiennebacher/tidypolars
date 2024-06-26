#' Replace NAs with specified values
#'
#' @param data A Polars Data/LazyFrame
#' @param replace Either a scalar that will be used to replace `NA` in all
#'   columns, or a named list with the column name and the value that will be
#'   used to replace `NA` in it. **The column type will be automatically
#'   converted to the type of the replacement value.**
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
#'
#' # be careful to use the same type for the replacement and for the column!
#' replace_na(pl_test, list(x = "a", y = "unknown"))

replace_na.RPolarsDataFrame <- function(data, replace, ...) {

  is_scalar <- length(replace) == 1 && !is.list(replace)

  out <- if (is_scalar) {
    data$with_columns(
      pl$all()$fill_null(replace)
    )
  } else if (is.list(replace)) {
    exprs <- list()
    for (i in seq_along(replace)) {
      exprs[[i]] <- polars::pl$col(names(replace)[i])$fill_null(replace[[i]])
    }
    data$with_columns(exprs)
  }

  add_tidypolars_class(out)
}

#' @rdname replace_na.RPolarsDataFrame
#' @export
replace_na.RPolarsLazyFrame <- replace_na.RPolarsDataFrame
