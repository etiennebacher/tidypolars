#' @export
pl_pivot_longer <- function(data, cols, names_to = "name", values_to = "value") {

  check_polars_data(data)

  data_names <- pl_colnames(data)
  value_vars <- .select_nse(data, cols)
  id_vars <- data_names[!data_names %in% value_vars]
  data$melt(id_vars = id_vars, value_vars = value_vars,
            variable_name = names_to, value_name = values_to)

}


#' @export
pl_pivot_wider <- function(data, id_cols, names_from, values_from) {

  check_polars_data(data)

  data_names <- pl_colnames(data)
  value_vars <- .select_nse(data, values_from)
  names_vars <- .select_nse(data, names_from)
  id_vars <- data_names[!data_names %in% c(value_vars, names_vars)]

  data$pivot(
    values = eval(value_vars), columns = eval(names_vars),
    index = eval(id_vars)
  )
}
