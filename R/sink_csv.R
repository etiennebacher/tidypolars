#' Stream output to a CSV file
#'
#' This function allows to stream a LazyFrame that is larger than RAM directly
#' to a `.csv` file without collecting it in the R session, thus preventing
#' crashes because of too small memory.
#'
#' @param .data A Polars LazyFrame.
#' @param has_header Whether to include header in the CSV output.
#' @param separator Separate CSV fields with this symbol.
#' @param line_terminator String used to end each row.
#' @param quote Byte to use as quoting character.
#' @param batch_size Number of rows that will be processed per thread.
#' @param datetime_format,date_format,time_format A format string used to format
#' date and time values. See `?strptime()` for accepted values. If no format
#' specified, the default fractional-second precision is inferred from the
#' maximum time unit found in the `Datetime` cols (if any).
#' @param float_precision Number of decimal places to write, applied to both
#' `Float32` and `Float64` datatypes.
#' @param null_values A string representing null values (defaulting to the empty
#' string).
#' @param quote_style Determines the quoting strategy used:
#' * `"necessary"` (default): This puts quotes around fields only when necessary.
#'   They are necessary when fields contain a quote, delimiter or record terminator.
#'   Quotes are also necessary when writing an empty record (which is
#'   indistinguishable from a record with one empty field).
#' * `"always"`: This puts quotes around every field.
#' * `"non_numeric"`: This puts quotes around all fields that are non-numeric.
#'   Namely, when writing a field that does not parse as a valid float or integer,
#'   then quotes will be used even if they aren't strictly necessary.
#'
#' @inheritParams sink_parquet
#'
#' @return Writes a `.csv` file with the content of the LazyFrame.
#' @export
#'
#' @examples
#' \dontrun{
#' # This is an example workflow where sink_csv() is not very useful because
#' # the data would fit in memory. It simply is an example of using it at the
#' # end of a piped workflow.
#'
#' # Create files for the CSV input and output:
#' file_csv <- tempfile(fileext = ".csv")
#' file_csv2 <- tempfile(fileext = ".csv")
#'
#' # Write some data in a CSV file
#' fake_data <- do.call("rbind", rep(list(mtcars), 1000))
#' write.csv(fake_data, file = file_csv)
#'
#' # In a new R session, we could read this file as a LazyFrame, do some operations,
#' # and write it to another CSV file without ever collecting it in the R session:
#' polars::pl$scan_csv(file_csv) |>
#'   filter(cyl %in% c(4, 6), mpg > 22) |>
#'   mutate(
#'     hp_gear_ratio = hp / gear
#'   ) |>
#'   sink_csv(path = file_csv2)
#'
#' }

sink_csv <- function(
    .data,
    path,
    has_header = TRUE,
    separator = ",",
    line_terminator = "\n",
    quote = '"',
    batch_size = 1024,
    datetime_format = NULL,
    date_format = NULL,
    time_format = NULL,
    float_precision = NULL,
    null_values = "",
    quote_style = "necessary",
    maintain_order = TRUE,
    type_coercion = TRUE,
    predicate_pushdown = TRUE,
    projection_pushdown = TRUE,
    simplify_expression = TRUE,
    slice_pushdown = TRUE,
    no_optimization = FALSE
  ) {

  if (!inherits(.data, "LazyFrame")) {
    rlang::abort("`sink_csv()` can only be used on a LazyFrame.")
  }

  .data$sink_csv(
    path = path,
    has_header = has_header,
    separator = separator,
    line_terminator = line_terminator,
    quote = quote,
    batch_size = batch_size,
    datetime_format = datetime_format,
    date_format = date_format,
    time_format = time_format,
    float_precision = float_precision,
    null_values = null_values,
    quote_style = quote_style,
    maintain_order = maintain_order,
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    no_optimization = no_optimization
  )

}

