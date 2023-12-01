#' Pivot Data/LazyFrame from long to wide
#'
#' @param data A Polars Data/LazyFrame
#' @param id_cols Defaults to all columns in data except for the columns specified
#'   through `names_from` and `values_from`.
#' @param names_from The (quoted or unquoted) column name whose values will be
#'   used for the names of the new columns.
#' @param values_from The (quoted or unquoted) column name whose values will be
#'   used to fill the new columns.
#' @param names_prefix String added to the start of every variable name. This is
#'  particularly useful if `names_from` is a numeric vector and you want to
#'  create syntactic variable names.
#' @param values_fill A scalar that will be used to replace missing values in the
#'   new columns. Note that the type of this value will be applied to new columns.
#'   For example, if you provide a character value to fill numeric columns, then
#'   all these columns will be converted to character.
#' @inheritParams slice_tail.DataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_fish_encounters <- polars::pl$DataFrame(tidyr::fish_encounters)
#'
#' pl_fish_encounters |>
#'   pivot_wider(names_from = station, values_from = seen)
#'
#' pl_fish_encounters |>
#'   pivot_wider(names_from = station, values_from = seen, values_fill = 0)
#'
#' # be careful about the type of the replacement value!
#' pl_fish_encounters |>
#'   pivot_wider(names_from = station, values_from = seen, values_fill = "a")

pivot_wider.DataFrame <- function(data, ..., id_cols, names_from, values_from,
                                  names_prefix = NULL, values_fill = NULL) {

  check_polars_data(data)

  data_names <- pl_colnames(data)
  value_vars <- tidyselect_named_arg(data, rlang::enquo(values_from))
  names_vars <- tidyselect_named_arg(data, rlang::enquo(names_from))
  id_vars <- data_names[!data_names %in% c(value_vars, names_vars)]

  new_cols <- pull(data, names_vars) |>
    unique() |>
    as.character()

  data <- data$pivot(
    values = value_vars,
    columns = names_vars,
    index = id_vars
  )

  if (!is.null(names_prefix)) {
    if (length(names_prefix) > 1) {
      rlang::abort(
        "`names_prefix` must be of length 1."
      )
    }
    new_names <- as.list(new_cols)
    names(new_names) <- paste0(names_prefix, new_cols)
    data <- data$rename(new_names)
  }

  if (!is.null(values_fill)) {
    data$with_columns(
      pl$col(new_cols)$fill_null(values_fill)
    )
  } else {
    data
  }
}

#' @rdname pivot_wider.DataFrame
#' @export
pivot_wider.LazyFrame <- pivot_wider.DataFrame
