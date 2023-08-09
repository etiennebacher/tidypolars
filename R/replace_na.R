#' Replace NAs with specified values
#'
#' @param .data A Polars Data/LazyFrame
#' @param replace Either a scalar that will be used to replace `NA` in all
#'   columns, or a named list with the column name and the value that will be
#'   used to replace `NA` in it. **The column type will be automatically
#'   converted to the type of the replacement value.**
#'
#' @export
#' @examples
#' pl_test <- polars::pl$DataFrame(x = c(NA, 1), y = c(2, NA))
#'
#' # replace all NA with 0
#' pl_replace_na(pl_test, 0)
#'
#' # custom replacement per column
#' pl_replace_na(pl_test, list(x = 0, y = 999))
#'
#' # be careful to use the same type for the replacement and for the column!
#' pl_replace_na(pl_test, list(x = "a", y = "unknown"))

pl_replace_na <- function(.data, replace) {

  check_polars_data(.data)
  is_scalar <- length(replace) == 1 && !is.list(replace)

  if (is_scalar) {
    .data$with_columns(
      pl$all()$fill_null(replace)
    )
  } else if (is.list(replace)) {
    exprs <- list()
    for (i in seq_along(replace)) {
      exprs[[i]] <- polars::pl$col(names(replace)[i])$fill_null(replace[[i]])
    }
    .data$with_columns(exprs)
  }
}
