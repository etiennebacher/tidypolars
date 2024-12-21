#' Complete a data frame with missing combinations of data
#'
#' Turns implicit missing values into explicit missing values. This is useful
#' for completing missing combinations of data.
#'
#' @param data A Polars Data/LazyFrame
#' @param ... Any expression accepted by `dplyr::select()`: variable names,
#'  column numbers, select helpers, etc.
#' @param fill A named list that for each variable supplies a single value to
#' use instead of `NA` for missing combinations.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' df <- polars::pl$DataFrame(
#'   group = c(1:2, 1, 2),
#'   item_id = c(1:2, 2, 3),
#'   item_name = c("a", "a", "b", "b"),
#'   value1 = c(1, NA, 3, 4),
#'   value2 = 4:7
#' )
#' df
#'
#' df |> complete(group, item_id, item_name)
#'
#' df |>
#'   complete(
#'     group, item_id, item_name,
#'     fill = list(value1 = 0, value2 = 99)
#'   )
#'
#' df |>
#'   group_by(group, maintain_order = TRUE) |>
#'   complete(item_id, item_name)

complete.RPolarsDataFrame <- function(data, ..., fill = list()) {
	vars <- tidyselect_dots(data, ...)
	if (length(vars) < 2) return(data)

	grps <- attributes(data)$pl_grps
	mo <- attributes(data)$maintain_grp_order
	is_grouped <- !is.null(grps)

	if (isTRUE(is_grouped)) {
		chain <- data$group_by(grps, maintain_order = mo)$agg(
			pl$col(vars)$unique()$sort()
		)
	} else {
		chain <- data$select(pl$col(vars)$unique()$sort()$implode())
	}

	for (i in seq_along(vars)) {
		chain <- chain$explode(vars[i])
	}

	if (isTRUE(is_grouped)) {
		out <- chain$join(data, on = c(grps, vars), how = 'left')
	} else {
		out <- chain$join(data, on = vars, how = 'left')
	}

	# TODO: implement argument `explicit`
	if (length(fill) > 0) {
		out <- replace_na(out, fill)
	}

	out <- if (is_grouped) {
		out |>
			relocate(all_of(grps), .before = 1) |>
			group_by(all_of(grps), maintain_order = mo)
	} else {
		out
	}

	add_tidypolars_class(out)
}

#' @rdname complete.RPolarsDataFrame
#' @export
complete.RPolarsLazyFrame <- complete.RPolarsDataFrame
