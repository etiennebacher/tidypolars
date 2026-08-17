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
select.polars_data_frame <- function(.data, ...) {
  .data <- tag_frame(.data, substitute(.data))
  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order %||% FALSE
  dots <- get_dots(...)
  with_renaming <- !is.null(names(dots))
  vars <- tidyselect_dots(.data, ..., with_renaming = with_renaming)

  # named means that we allow renaming in dots
  if (is_named(vars)) {
    data_names <- names(.data)
    selected_names <- data_names[unname(vars)]
    missing_grps <- setdiff(grps, selected_names)
    vars <- c(setNames(match(missing_grps, data_names), missing_grps), vars)
    grps <- names(vars)[match(grps, c(missing_grps, selected_names))]

    out <- .data[, unname(vars), drop = FALSE]
    ls <- as.list(names(vars))
    names(ls) <- names(out)
    out <- out$rename(!!!ls)
  } else {
    vars <- c(setdiff(grps, vars), vars)
    out <- .data$select(!!!vars)
  }
  if (length(grps) > 0) {
    out <- group_by(out, all_of(grps), maintain_order = mo)
  }
  add_tidypolars_class(out)
}

#' @rdname select.polars_data_frame
#' @export
select.polars_lazy_frame <- select.polars_data_frame
