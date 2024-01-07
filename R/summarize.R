#' Summarize each group down to one row
#'
#' `summarize()` returns one row for each combination of grouping variables
#' (one difference with `dplyr::summarize()` is that `summarize()` only
#' accepts grouped data). It will contain one column for each grouping variable
#' and one column for each of the summary statistics that you have specified.
#'
#' @param .data A Polars Data/LazyFrame
#' @inheritParams mutate.RPolarsDataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' mtcars |>
#'   as_polars_df() |>
#'   group_by(cyl) |>
#'   summarize(m_gear = mean(gear), sd_gear = sd(gear))
#'
#' # an alternative syntax is to use `.by`
#' mtcars |>
#'   as_polars_df() |>
#'   summarize(m_gear = mean(gear), sd_gear = sd(gear), .by = cyl)


summarize.RPolarsDataFrame <- function(.data, ..., .by = NULL) {

  check_polars_data(.data)

  grps <- get_grps(.data, rlang::enquo(.by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  if (is.null(mo)) mo <- FALSE
  is_grouped <- !is.null(grps)

  # do not take the groups into account, especially useful when applying across()
  # on everything()
  .data_for_translation <- select(.data, -all_of(grps))
  polars_exprs <- translate_dots(
    .data = .data_for_translation,
    ...,
    env = rlang::current_env()
  )

  for (i in seq_along(polars_exprs)) {
    sub <- polars_exprs[[i]]
    to_drop <- names(empty_elems(sub))
    sub <- compact(sub)

    if (length(sub) > 0) {
      if (is_grouped) {
        .data <- .data$group_by(grps, maintain_order = mo)$agg(sub)
      } else {
        .data <- .data$select(sub)
      }
    }

    if (length(to_drop) > 0) {
      .data <- .data$drop(to_drop)
    }
  }

  if (is_grouped && missing(.by)) {
    group_by(.data, grps, maintain_order = mo)
  } else {
    .data
  }
}

#' @rdname summarize.RPolarsDataFrame
#' @export
summarise.RPolarsDataFrame <- summarize.RPolarsDataFrame

#' @rdname summarize.RPolarsDataFrame
#' @export
summarize.RPolarsLazyFrame <- summarize.RPolarsDataFrame

#' @rdname summarize.RPolarsDataFrame
#' @export
summarise.RPolarsLazyFrame <- summarize.RPolarsDataFrame
