#' Group by one or more variables
#'
#' Most data operations are done on groups defined by variables. `group_by()`
#' takes an existing Polars Data/LazyFrame and converts it into a grouped one
#' where operations are performed "by group". `ungroup()` removes grouping.
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Variables to group by (used in `group_by()` only). Not used in
#' `ungroup()`.
#' @param maintain_order Maintain row order. For performance reasons, this is
#' `FALSE` by default). Setting it to `TRUE` can slow down the process with
#' large datasets and prevents the use of streaming.
#' @param .add When `FALSE` (default), `group_by()` will override existing
#' groups. To add to the existing groups, use `.add = TRUE`.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' by_cyl <- mtcars |>
#'   as_polars_df() |>
#'   group_by(cyl)
#'
#' by_cyl
#'
#' by_cyl |> summarise(
#'   disp = mean(disp),
#'   hp = mean(hp)
#' )
#' by_cyl |> filter(disp == max(disp))
#'
group_by.RPolarsDataFrame <- function(
	.data,
	...,
	maintain_order = FALSE,
	.add = FALSE
) {
	if (isTRUE(attributes(.data)$grp_type == "rowwise")) {
		rlang::abort(
			c(
				"Cannot use `group_by()` if `rowwise()` is also used.",
				"i" = "Use `ungroup()` first, and then `group_by()`."
			)
		)
	}

	vars <- tidyselect_dots(.data, ...)

	if (isTRUE(.add)) {
		existing_groups <- attributes(.data)$pl_grps
		vars <- unique(c(existing_groups, vars))
	}

	if (length(vars) == 0) {
		return(.data)
	}
	# need to clone, otherwise the data gets attributes, even if unassigned
	.data2 <- .data$clone()
	attr(.data2, "pl_grps") <- vars
	attr(.data2, "maintain_grp_order") <- maintain_order
	add_tidypolars_class(.data2)
}

#' @param x A Polars Data/LazyFrame
#' @rdname group_by.RPolarsDataFrame
#' @export

ungroup.RPolarsDataFrame <- function(x, ...) {
	attributes(x)$pl_grps <- NULL
	attributes(x)$maintain_grp_order <- NULL
	attributes(x)$grp_type <- NULL
	x
}

#' @rdname group_by.RPolarsDataFrame
#' @export
group_by.RPolarsLazyFrame <- group_by.RPolarsDataFrame

#' @rdname group_by.RPolarsDataFrame
#' @export
ungroup.RPolarsLazyFrame <- ungroup.RPolarsDataFrame

#' Grouping metadata
#'
#' `group_vars()` returns a character vector with the names of the grouping
#' variables. `group_keys()` returns a data frame with one row per group.
#'
#' @param x,.tbl A Polars Data/LazyFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE)
#' pl_g <- polars::as_polars_df(mtcars) |>
#'   group_by(cyl, am)
#'
#' group_vars(pl_g)
#'
#' group_keys(pl_g)
group_vars.RPolarsDataFrame <- function(x) {
	grps <- attributes(x)$pl_grps
	if (length(grps) > 0) {
		grps
	} else {
		character(0)
	}
}

#' @rdname group_vars.RPolarsDataFrame
#' @export
group_vars.RPolarsLazyFrame <- group_vars.RPolarsDataFrame

#' @rdname group_vars.RPolarsDataFrame
#' @inheritParams rlang::args_dots_empty
#' @export
group_keys.RPolarsDataFrame <- function(.tbl, ...) {
	grps <- attributes(.tbl)$pl_grps
	if (length(grps) > 0) {
		out <- .tbl$group_by(grps)$agg(pl$lit(1))$drop("literal")$sort(grps)

		if (inherits(out, "RPolarsLazyFrame")) {
			out <- out$collect()
		}
		out$to_data_frame()
	} else {
		data.frame()
	}
}

#' @rdname group_vars.RPolarsDataFrame
#' @export
group_keys.RPolarsLazyFrame <- group_keys.RPolarsDataFrame

#' Grouping metadata
#'
#' `group_vars()` returns a character vector with the names of the grouping
#' variables. `group_keys()` returns a data frame with one row per group.
#'
#' @param .tbl A Polars Data/LazyFrame
#' @param ... If `.tbl` is not grouped, variables to group by. If `.tbl` is
#' already grouped, this is ignored.
#' @param .keep Should the grouping columns be kept?
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE)
#' pl_g <- polars::as_polars_df(iris) |>
#'   group_by(Species)
#'
#' group_split(pl_g)
group_split.RPolarsDataFrame <- function(.tbl, ..., .keep = TRUE) {
	grps <- attributes(.tbl)$pl_grps
	dots <- tidyselect_dots(.tbl, ...)

	if (length(grps) > 0 && length(dots) > 0) {
		warn("`.tbl` is already grouped so variables in `...` are ignored.")
	}

	grps <- grps %||% dots

	.tbl$partition_by(grps, include_key = .keep)
}
