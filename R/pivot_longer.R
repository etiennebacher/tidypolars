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
#' @inheritParams rlang::check_dots_empty0
#'
#' @inheritSection left_join.polars_data_frame Unknown arguments
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_relig_income <- as_polars_df(tidyr::relig_income)
#' pl_relig_income
#'
#' pl_relig_income |>
#'   pivot_longer(!religion, names_to = "income", values_to = "count")
#'
#' pl_billboard <- as_polars_df(tidyr::billboard)
#' pl_billboard
#'
#' pl_billboard |>
#'   pivot_longer(
#'     cols = starts_with("wk"),
#'     names_to = "week",
#'     names_prefix = "wk",
#'     values_to = "rank",
#'   )
pivot_longer.polars_data_frame <- function(
  data,
  cols,
  ...,
  names_to = "name",
  names_prefix = NULL,
  values_to = "value"
) {
  check_dots_empty_ignore(
    ...,
    .unsupported = c(
      "cols_vary",
      "names_sep",
      "names_pattern",
      "names_ptypes",
      "names_transform",
      "names_repair",
      "values_drop_na",
      "values_ptypes",
      "values_transform"
    )
  )
  check_string(names_prefix, allow_null = TRUE)

  data_names <- names(data)
  on <- tidyselect_named_arg(data, rlang::enquo(cols))
  index <- data_names[!data_names %in% on]
  out <- data$unpivot(
    index = index,
    on = on,
    variable_name = names_to,
    value_name = values_to
  )$sort(index)

  if (!is.null(names_prefix)) {
    out <- out$with_columns(
      pl$col(!!!names_to)$str$replace(paste0("^", names_prefix), "")
    )
  }

  add_tidypolars_class(out)
}

#' @rdname pivot_longer.polars_data_frame
#' @export
pivot_longer.polars_lazy_frame <- pivot_longer.polars_data_frame
