#' Separate a character column into multiple columns based on a substring
#'
#' Currently, splitting a column on a regular expression or position is not
#' possible.
#'
#' @param data A Polars Data/LazyFrame
#' @param col Column to split
#' @param into Character vector containing the names of new variables to create.
#' Use `NA` to omit the variable in the output.
#' @param sep String that is used to split the column. Regular expressions are
#' not supported yet.
#' @param remove If `TRUE`, remove input column from output data frame.
#' @inheritParams slice_tail.polars_data_frame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- neopolars::pl$DataFrame(
#'   x = c(NA, "x.y", "x.z", "y.z")
#' )
#' separate(test, x, into = c("foo", "foo2"), sep = ".")

separate.polars_data_frame <- function(
  data,
  col,
  into,
  sep = " ",
  remove = TRUE,
  ...
) {
  col <- deparse(substitute(col))

  into_len <- length(into) - 1
  # to avoid collision with an existing col
  temp_id <- paste(sample(letters), collapse = "")

  data <- data$with_columns(
    pl$col(col)$cast(pl$Utf8)$str$split_exact(sep, into_len)$alias(
      temp_id
    )$struct$rename_fields(into)
  )$unnest(temp_id)

  if (isTRUE(remove)) {
    data <- data$drop(col)
  }

  add_tidypolars_class(data)
}

#' @rdname separate.polars_data_frame
#' @export
separate.polars_lazy_frame <- separate.polars_data_frame
