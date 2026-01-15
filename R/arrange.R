#' Order rows using column values
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Variables, or functions of variables. Use `desc()` to sort a
#' variable in descending order.
#' @param .by_group If `TRUE`, will sort data within groups.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_test <- polars::pl$DataFrame(
#'   x1 = c("a", "a", "b", "a", "c"),
#'   x2 = c(2, 1, 5, 3, 1),
#'   value = sample(1:5)
#' )
#'
#' arrange(pl_test, x1)
#' arrange(pl_test, x1, -x2)
#'
#' # if the data is grouped, you need to specify `.by_group = TRUE` to sort by
#' # the groups first
#' pl_test |>
#'   group_by(x1) |>
#'   arrange(-x2, .by_group = TRUE)

arrange.polars_data_frame <- function(.data, ..., .by_group = FALSE) {
  grps <- attributes(.data)$pl_grps
  mo <- attributes(data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  attr(.data, "called_from_arrange") <- TRUE

  polars_exprs <- translate_dots(
    .data,
    ...,
    env = rlang::current_env(),
    caller = rlang::caller_env()
  )

  descending <- vapply(
    polars_exprs,
    function(x) {
      attr(x, "descending") %||% FALSE
    },
    FUN.VALUE = logical(1L)
  )

  # We want to allow sort expressions of length 1 (e.g. `arrange("a")`). This
  # isn't doing anything on the sort but dplyr allows it.
  polars_exprs <- lapply(seq_along(polars_exprs), function(x) {
    if (!is_polars_expr(polars_exprs[[x]])) {
      polars_exprs[[x]] <- pl$lit(polars_exprs[[x]])
    }
    polars_exprs[[x]]$alias(paste0("__TIDYPOLARS_TEMP_SORT__", x))
  })

  names_exprs <- lapply(polars_exprs, function(x) {
    x$meta$output_name()
  })

  if (is_grouped && isTRUE(.by_group)) {
    to_sort_with <- c(grps, names_exprs)
    descending <- c(rep(FALSE, length(grps)), descending)
  } else {
    to_sort_with <- names_exprs
  }

  out <- .data$with_columns(!!!polars_exprs)$sort(
    !!!to_sort_with,
    descending = descending,
    nulls_last = TRUE
  )$drop(!!!names_exprs)

  if (is_grouped) {
    out <- out |>
      group_by(all_of(grps), maintain_order = mo)
  }

  add_tidypolars_class(out)
}

#' @export
arrange.polars_lazy_frame <- arrange.polars_data_frame
