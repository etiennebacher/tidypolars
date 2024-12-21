#' Select columns from a Data/LazyFrame
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Any expression accepted by `dplyr::select()`: variable names,
#'  column numbers, select helpers, etc. Renaming is also possible.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#'
#' pl_iris <- polars::as_polars_df(iris)
#'
#' select(pl_iris, c("Sepal.Length", "Sepal.Width"))
#' select(pl_iris, Sepal.Length, Sepal.Width)
#' select(pl_iris, 1:3)
#' select(pl_iris, starts_with("Sepal"))
#' select(pl_iris, -ends_with("Length"))
#'
#' # Renaming while selecting is also possible
#' select(pl_iris, foo1 = Sepal.Length, Sepal.Width)
select.RPolarsDataFrame <- function(.data, ...) {
	dots <- get_dots(...)
	with_renaming <- !is.null(names(dots))
	vars <- tidyselect_dots(.data, ..., with_renaming = with_renaming)

	# named means that we allow renaming in dots
	if (is_named(vars)) {
		out <- .data[, unname(vars), drop = FALSE]
		ls <- as.list(names(vars))
		names(ls) <- names(out)
		out <- out$rename(ls)
	} else {
		out <- .data$select(vars)
	}
	add_tidypolars_class(out)
}

#' @rdname select.RPolarsDataFrame
#' @export
select.RPolarsLazyFrame <- select.RPolarsDataFrame
