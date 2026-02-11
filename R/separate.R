#' Separate a character column into multiple columns based on a substring
#'
#' Currently, splitting a column on a position is not possible.
#'
#' @param data A Polars Data/LazyFrame
#' @param col Column to split
#' @param into Character vector containing the names of new variables to create.
#' Use `NA` to omit the variable in the output.
#' @param sep A regular expression that is used to split the column.
#' @param remove If `TRUE`, remove input column from output data frame.
#' @inheritParams slice_tail.polars_data_frame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' # Split at each dot
#' test <- polars::pl$DataFrame(x = c(NA, "x.y", "x.z", "y.z"))
#' separate(test, x, into = c("foo", "foo2"), sep = "\\.")
#'
#' # Split on any number of whitespace
#' test <- polars::pl$DataFrame(x = c(NA, "x y", "x  y", "x y  z"))
#' separate(test, x, into = c("foo", "foo2"), sep = "\\s+")
separate.polars_data_frame <- function(
  data,
  col,
  into,
  sep = " ",
  remove = TRUE,
  ...
) {
  if (!is_character(sep)) {
    cli_abort(
      "{.pkg tidypolars} only supports a character for argument {.arg sep} in {.fn separate}."
    )
  }
  col <- deparse(substitute(col))

  data <- data$with_columns(
    pl$col(col)$cast(pl$String)$str$split(sep, literal = FALSE)$list$to_struct(
      upper_bound = length(into)
    )$struct$rename_fields(into)$struct$unnest()
  )

  if (isTRUE(remove)) {
    data <- data$drop(col)
  }

  add_tidypolars_class(data)
}

#' @rdname separate.polars_data_frame
#' @export
separate.polars_lazy_frame <- separate.polars_data_frame
