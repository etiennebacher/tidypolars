#' Pivot a Data/LazyFrame from wide to long
#'
#' @param data A Polars Data/LazyFrame
#' @param cols Columns to pivot into longer format. Can be anything accepted by
#'  `dplyr::select()`.
#' @param names_to The (quoted) name of the column that will contain the column
#'  names specified by `cols`.
#' @param names_prefix A regular expression used to remove matching text from
#'  the start of each variable name.
#' @param values_to A string specifying the name of the column to create from the
#'  data stored in cell values.
#' @inheritParams slice_tail.RPolarsDataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_relig_income <- polars::pl$DataFrame(tidyr::relig_income)
#' pl_relig_income
#'
#' pl_relig_income |>
#'   pivot_longer(!religion, names_to = "income", values_to = "count")
#'
#' pl_billboard <- polars::pl$DataFrame(tidyr::billboard)
#' pl_billboard
#'
#' pl_billboard |>
#'   pivot_longer(
#'     cols = starts_with("wk"),
#'     names_to = "week",
#'     names_prefix = "wk",
#'     values_to = "rank",
#'   )

pivot_longer.RPolarsDataFrame <- function(data, cols, ..., names_to = "name",
                                   names_prefix = NULL,
                                   values_to = "value") {

  check_polars_data(data)

  data_names <- pl_colnames(data)
  value_vars <- tidyselect_named_arg(data, rlang::enquo(cols))
  id_vars <- data_names[!data_names %in% value_vars]
  out <- data$melt(
    id_vars = id_vars, value_vars = value_vars,
    variable_name = names_to, value_name = values_to
  )$sort(id_vars)

  if (!is.null(names_prefix)) {
    if (length(names_prefix) > 1) {
      rlang::abort(
        "`names_prefix` must be of length 1."
      )
    }
    out <- out$
      with_columns(
        pl$col(names_to)$str$replace(paste0("^", names_prefix), "")
      )
  }

  add_tidypolars_class(out)
}

#' @rdname pivot_longer.RPolarsDataFrame
#' @export
pivot_longer.RPolarsLazyFrame <- pivot_longer.RPolarsDataFrame
