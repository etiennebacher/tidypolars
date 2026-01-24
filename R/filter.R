#' Keep or drop rows that match a condition
#'
#' @description
#' These functions are used to subset a data frame, applying the expressions in `...` to
#' determine which rows should be kept (for `filter()`) or dropped (for `filter_out()`).
#'
#' Multiple conditions can be supplied separated by a comma. These will be combined with
#' the `&` operator.
#'
#' Both `filter()` and `filter_out()` treat `NA` like `FALSE`. This subtle behavior can impact
#' how you write your conditions when missing values are involved. See the section on `Missing
#' values` for important details and examples.
#'
#' `filter_out()` is available for `dplyr` >= 1.2.0.
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Expressions that return a logical value, and are defined in terms
#' of the variables in the data. If multiple expressions are included, they
#' will be combined with the & operator. Only rows for which all conditions
#' evaluate to `TRUE` are kept (for `filter()`) or dropped (for `filter_out()`).
#' @inheritParams mutate.polars_data_frame
#'
#' @section Missing values:
#'
#' Read this section in the [`dplyr` documentation](https://dplyr.tidyverse.org/dev/reference/filter.html#missing-values).
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' starwars <- as_polars_df(dplyr::starwars)
#'
#' # Filtering for one criterion
#' filter(starwars, species == "Human")
#'
#' # Filtering for multiple criteria within a single logical expression
#' filter(starwars, hair_color == "none" & eye_color == "black")
#' filter(starwars, hair_color == "none" | eye_color == "black")
#'
#' # When multiple expressions are used, they are combined using &
#' filter(starwars, hair_color == "none", eye_color == "black")
#'
#' # Filtering out to drop rows
#' filter_out(starwars, hair_color == "none")
#'
#' # When filtering out, it can be useful to first interactively filter for the
#' # rows you want to drop, just to double check that you've written the
#' # conditions correctly. Then, just change `filter()` to `filter_out()`.
#' filter(starwars, mass > 1000, eye_color == "orange")
#' filter_out(starwars, mass > 1000, eye_color == "orange")
#'
#' # The filtering operation may yield different results on grouped
#' # tibbles because the expressions are computed within groups.
#' #
#' # The following keeps rows where `mass` is greater than the
#' # global average:
#' starwars |> filter(mass > mean(mass, na.rm = TRUE))
#'
#' # Whereas this keeps rows with `mass` greater than the per `gender`
#' # average:
#' starwars |> filter(mass > mean(mass, na.rm = TRUE), .by = gender)
#'
#' # If you find yourself trying to use a `filter()` to drop rows, then
#' # you should consider if switching to `filter_out()` can simplify your
#' # conditions. For example, to drop blond individuals, you might try:
#' starwars |> filter(hair_color != "blond")
#'
#' # But this also drops rows with an `NA` hair color! To retain those:
#' starwars |> filter(hair_color != "blond" | is.na(hair_color))
#'
#' # But explicit `NA` handling like this can quickly get unwieldy, especially
#' # with multiple conditions. Since your intent was to specify rows to drop
#' # rather than rows to keep, use `filter_out()`. This also removes the need
#' # for any explicit `NA` handling.
#' starwars |> filter_out(hair_color == "blond")
#'
#' # To refer to column names that are stored as strings, use the `.data`
#' # pronoun:
#' vars <- c("mass", "height")
#' cond <- c(80, 150)
#' starwars |>
#'   filter(
#'     .data[[vars[[1]]]] > cond[[1]],
#'     .data[[vars[[2]]]] > cond[[2]]
#'   )
filter.polars_data_frame <- function(.data, ..., .by = NULL) {
  grps <- get_grps(.data, rlang::enquo(.by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  polars_exprs <- translate_dots(
    .data,
    ...,
    env = rlang::current_env(),
    caller = rlang::caller_env()
  )

  # Happens if `...` has length 0, e.g. `filter(!!!list())`
  if (is.null(polars_exprs)) {
    polars_exprs <- list(TRUE)
  }

  if (is_grouped) {
    polars_exprs <- lapply(polars_exprs, \(x) x$over(!!!grps))
  }

  # this is only applied between expressions that were separated by a comma
  # in the filter() call. So it won't replace the "|" call.
  polars_exprs <- Reduce(`&`, polars_exprs)

  tryCatch(
    {
      out <- .data$filter(polars_exprs)
    },
    error = function(e) {
      cli_abort(e$message, call = caller_env(4))
    }
  )
  out <- if (is_grouped && missing(.by)) {
    group_by(out, all_of(grps), maintain_order = mo)
  } else {
    out
  }

  add_tidypolars_class(out)
}

#' @rdname filter.polars_data_frame
#' @export
filter.polars_lazy_frame <- filter.polars_data_frame

#' @rdname filter.polars_data_frame
#' @export
filter_out.polars_data_frame <- function(.data, ..., .by = NULL) {
  grps <- get_grps(.data, rlang::enquo(.by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  polars_exprs <- translate_dots(
    .data,
    ...,
    env = rlang::current_env(),
    caller = rlang::caller_env()
  )

  # Happens if `...` has length 0, e.g. `filter_out(!!!list())`
  if (is.null(polars_exprs)) {
    polars_exprs <- list(TRUE)
  }

  if (is_grouped) {
    polars_exprs <- lapply(polars_exprs, \(x) x$over(!!!grps))
  }

  # this is only applied between expressions that were separated by a comma
  # in the filter() call. So it won't replace the "|" call.
  polars_exprs <- Reduce(`&`, polars_exprs)

  tryCatch(
    {
      out <- .data$remove(polars_exprs)
    },
    error = function(e) {
      cli_abort(e$message, call = caller_env(4))
    }
  )
  out <- if (is_grouped && missing(.by)) {
    group_by(out, all_of(grps), maintain_order = mo)
  } else {
    out
  }

  add_tidypolars_class(out)
}

#' @rdname filter.polars_data_frame
#' @export
filter_out.polars_lazy_frame <- filter_out.polars_data_frame
