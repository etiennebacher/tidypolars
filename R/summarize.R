#' Summarize each group down to one row
#'
#' `summarize()` returns one row for each combination of grouping variables
#' (one difference with `dplyr::summarize()` is that `summarize()` only
#' accepts grouped data). It will contain one column for each grouping variable
#' and one column for each of the summary statistics that you have specified.
#'
#' @param .data A Polars Data/LazyFrame
#' @inheritParams mutate.RPolarsDataFrame
#' @param .groups Grouping structure of the result. Must be one of:
#' * `"drop_last"` (default): drop the last level of grouping;
#' * `"drop"`: all levels of grouping are dropped;
#' * `"keep"`: keep the same grouping structure as `.data`.
#'
#' For now, `"rowwise"` is not supported. Note that `dplyr` uses `.groups =
#' NULL` by default, whose behavior depends on the number of rows by group in
#' the output. However, returning several rows by group in `summarize()` is
#' deprecated (one should use `reframe()` instead), which is why `.groups =
#' NULL` is not supported by `tidypolars`.
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
summarize.RPolarsDataFrame <- function(.data, ..., .by = NULL, .groups = "drop_last") {
  grps <- get_grps(.data, rlang::enquo(.by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  if (is.null(mo)) mo <- FALSE
  is_grouped <- !is.null(grps)
  is_rowwise <- attributes(.data)$grp_type == "rowwise"

  # Technically, .groups can be NULL and then the value depends on the number
  # of rows for each group after aggregation, but returning multiple rows is
  # deprecated so I only use those 4 values.
  .groups <- rlang::arg_match0(.groups, values = c("drop_last", "drop", "keep", "rowwise"))
  if (.groups == "rowwise") {
    abort("`tidypolars` doesn't support `.groups = \"rowwise\"` for now.")
  }

  # Do not take the groups into account, especially useful when applying across()
  # on everything().
  .data_for_translation <- select(.data, -all_of(grps))
  polars_exprs <- translate_dots(
    .data = .data_for_translation,
    ...,
    env = rlang::current_env(),
    caller = rlang::caller_env()
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

  out <- if (is_grouped && missing(.by)) {
    grps <- switch(.groups,
      "drop_last" = grps[-length(grps)],
      "drop" = character(0),
      "keep" = grps,
      abort("Unreachable")
    )
    if (length(grps) == 0) {
      return(.data)
    }
    group_by(.data, all_of(grps), maintain_order = mo)
  } else if (isTRUE(is_rowwise)) {
    rowwise(.data)
  } else {
    .data
  }

  add_tidypolars_class(out)
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
