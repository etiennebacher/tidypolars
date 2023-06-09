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
#' pl_relig_income <- polars::pl$DataFrame(relig_income)
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


#' @export
pl_pivot_wider <- function(data, id_cols, names_from, values_from) {

  check_polars_data(data)

  data_names <- pl_colnames(data)
  value_vars <- .select_nse_from_dots(data, values_from)
  names_vars <- .select_nse_from_dots(data, names_from)
  id_vars <- data_names[!data_names %in% c(value_vars, names_vars)]

  data$pivot(
    values = eval(value_vars), columns = eval(names_vars),
    index = eval(id_vars)
  )
}
