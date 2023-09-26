#' Separate a character column into multiple columns based on a substring
#'
#' Currently, splitting a column on a regular expression or position is not
#' possible.
#'
#' @param .data A Polars Data/LazyFrame
#' @param col Column to split
#' @param into Character vector containing the names of new variables to create.
#' Use `NA` to omit the variable in the output.
#' @param sep String that is used to split the column.
#' @param remove If `TRUE`, remove input column from output data frame.
#'
#' @export
#' @examples
#' test <- polars::pl$DataFrame(
#'   x = c(NA, "x.y", "x.z", "y.z")
#' )
#' pl_separate(test, x, into = c("foo", "foo2"), sep = ".")

pl_separate <- function(.data, col, into, sep = "[^[:alnum:]]+", remove = TRUE) {

  check_polars_data(.data)

  # TODO: remove this when 0.9.0 is released
  if (inherits(.data, "LazyFrame") && packageVersion("polars") <= "0.8.1") {
    abort("`pl_separate()` only works on LazyFrames with polars > 0.8.1. Try to install a more recent version of polars.")
  }

  col <- deparse(substitute(col))

  into_len <- length(into) - 1
  # to avoid collision with an existing col
  temp_id <- paste(sample(letters), collapse = "")

  .data <- .data$
    with_columns(
      pl$col(col)$cast(pl$Utf8)$
        str$split_exact(sep, into_len)$
        alias(temp_id)$
        struct$
        rename_fields(into)
    )$unnest(temp_id)

  if (isTRUE(remove)) {
    .data <- .data$drop(col)
  }

  .data
}
