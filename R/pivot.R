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
pl_pivot_wider <- function(data, col, into, sep = "[^[:alnum:]]+", remove = TRUE) {


}
