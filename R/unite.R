#' Unite multiple columns into one by pasting strings together
#'
#' @param data A Polars Data/LazyFrame
#' @param col The name of the new column, as a string or symbol.
#' @inheritParams fill.RPolarsDataFrame
#' @param sep Separator to use between values.
#' @param remove If `TRUE`, remove input columns from the output Data/LazyFrame.
#' @param na.rm If `TRUE`, missing values will be replaced with an empty string
#' prior to uniting each value.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars::pl$DataFrame(
#'   year = 2009:2011,
#'   month = 10:12,
#'   day = c(11L, 22L, 28L),
#'   name_day = c("Monday", "Thursday", "Wednesday")
#' )
#'
#' # By default, united columns are dropped
#' unite(test, col = "full_date", year, month, day, sep = "-")
#' unite(test, col = "full_date", year, month, day, sep = "-", remove = FALSE)
#'
#' test2 <- polars::pl$DataFrame(
#'   name = c("John", "Jack", "Thomas"),
#'   middlename = c("T.", NA, "F."),
#'   surname = c("Smith", "Thompson", "Jones")
#' )
#'
#' # By default, NA values are kept in the character output
#' unite(test2, col = "full_name", everything(), sep = " ")
#' unite(test2, col = "full_name", everything(), sep = " ", na.rm = TRUE)

unite.RPolarsDataFrame <- function(
  data,
  col,
  ...,
  sep = "_",
  remove = TRUE,
  na.rm = FALSE
) {
  if (missing(col)) {
    rlang::abort("`col` is absent but must be supplied.")
  }
  vars <- tidyselect_dots(data, ...)
  if (length(vars) == 0) {
    vars <- names(data)
  }
  # can be a character or symbol
  col <- rlang::as_string(rlang::ensym(col))

  if (isTRUE(na.rm)) {
    fill <- ""
  } else {
    fill <- "NA"
  }

  vars_concat <- pl$col(vars)$fill_null(fill)

  out <- data$with_columns(
    pl$concat_str(vars_concat, separator = sep)$alias(col)
  )

  out <- if (isTRUE(remove)) {
    out$drop(vars)
  } else {
    out
  }

  add_tidypolars_class(out)
}

#' @rdname unite.RPolarsDataFrame
#' @export
unite.RPolarsLazyFrame <- unite.RPolarsDataFrame
