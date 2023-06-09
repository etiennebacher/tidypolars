#' Pivot Data/LazyFrame from wide to long
#'
#' @param data A Polars Data/LazyFrame
#' @param cols Columns to pivot into longer format. Can be anything accepted by
#'  `dplyr::select()`.
#' @param names_to The (quoted) name of the column that will contain the column
#'  names specified by `cols`.
#' @param values_to A string specifying the name of the column to create from the
#'  data stored in cell values.
#'
#' @export
#' @examples
#' pl_relig_income <- polars::pl$DataFrame(tidypolars::relig_income)
#' pl_relig_income
#'
#' pl_relig_income |>
#'   pl_pivot_longer(!religion, names_to = "income", values_to = "count")

pl_pivot_longer <- function(data, cols, names_to = "name", values_to = "value") {

  check_polars_data(data)

  data_names <- pl_colnames(data)
  cols <- deparse(substitute(cols))
  value_vars <- .select_nse_from_var(data, var = cols)
  id_vars <- data_names[!data_names %in% value_vars]
  data$melt(
    id_vars = id_vars, value_vars = value_vars,
    variable_name = names_to, value_name = values_to
  )$sort(eval(id_vars))

}

#' Pivot Data/LazyFrame from long to wide
#'
#' @param data A Polars Data/LazyFrame
#' @param id_cols Defaults to all columns in data except for the columns specified
#'   through `names_from` and `values_from`.
#' @param names_from The (quoted or unquoted) column name whose values will be
#'   used for the names of the new columns.
#' @param values_from The (quoted or unquoted) column name whose values will be
#'   used to fill the new columns.
#' @param values_fill A scalar that will be used to replace missing values in the
#'   new columns. Note that the type of this value will be applied to new columns.
#'   For example, if you provide a character value to fill numeric columns, then
#'   all these columns will be converted to character.
#'
#' @export
#' @examples
#' pl_fish_encounters <- polars::pl$DataFrame(tidypolars::fish_encounters)
#'
#' pl_fish_encounters |>
#'   pl_pivot_wider(names_from = station, values_from = seen)
#'
#' pl_fish_encounters |>
#'   pl_pivot_wider(names_from = station, values_from = seen, values_fill = 0)
#'
#' # be careful about the type of the replacement value!
#' pl_fish_encounters |>
#'   pl_pivot_wider(names_from = station, values_from = seen, values_fill = "a")

pl_pivot_wider <- function(data, id_cols, names_from, values_from,
                           values_fill = NULL) {

  check_polars_data(data)

  data_names <- pl_colnames(data)
  values_from <- deparse(substitute(values_from))
  names_from <- deparse(substitute(names_from))
  value_vars <- .select_nse_from_var(data, values_from)
  names_vars <- .select_nse_from_var(data, names_from)
  id_vars <- data_names[!data_names %in% c(value_vars, names_vars)]

  to_fill <- pl_pull(data, names_vars) |>
    unique() |>
    as.character()

  data <- data$pivot(
    values = eval(value_vars),
    columns = eval(names_vars),
    index = eval(id_vars)
  )

  if (!is.null(values_fill)) {
    data$with_columns(
      pl$col(eval(to_fill))$fill_null(values_fill)
    )
  } else {
    data
  }
}
