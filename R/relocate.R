#' Change column order
#'
#' Use `relocate()` to change column positions, using the same syntax as
#' `select()` to make it easy to move blocks of columns at once.
#'
#' @inheritParams fill.RPolarsDataFrame
#' @param .before,.after Column name (either quoted or unquoted) that
#' indicates the destination of columns selected by `...`. Supplying neither
#' will move columns to the left-hand side; specifying both is an error.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' dat <- as_polars_df(mtcars)
#'
#' dat |>
#'   relocate(hp, vs, .before = cyl)
#'
#' # if .before and .after are not specified, selected columns are moved to the
#' # first positions
#' dat |>
#'   relocate(hp, vs)
#'
#' # .before and .after can be quoted or unquoted
#' dat |>
#'   relocate(hp, vs, .after = "gear")
#'
#' # select helpers are also available
#' dat |>
#'   relocate(contains("[aeiou]"))
#'
#' dat |>
#'   relocate(hp, vs, .after = last_col())

relocate.RPolarsDataFrame <- function(
  .data,
  ...,
  .before = NULL,
  .after = NULL
) {
  if (!missing(.before) && !missing(.after)) {
    cli_abort(
      "You can specify either {.code .before} or {.code .after} but not both."
    )
  }

  names_data <- names(.data)

  if (missing(.before) && missing(.after)) {
    .before <- names_data[1]
    where <- "BEFORE"
  } else if (!missing(.before) && missing(.after)) {
    .before <- tidyselect_named_arg(.data, rlang::enquo(.before))
    where <- "BEFORE"
  } else if (missing(.before) && !missing(.after)) {
    .after <- tidyselect_named_arg(.data, rlang::enquo(.after))
    where <- "AFTER"
  }

  vars <- tidyselect_dots(.data, ...)
  if (length(vars) == 0) {
    return(add_tidypolars_class(.data))
  }

  not_moving <- setdiff(names_data, vars)

  if (where == "BEFORE") {
    limit <- which(names_data == .before) - 1
    lhs <- names_data[seq_len(limit)]
    lhs <- lhs[which(lhs %in% not_moving)]
    rhs <- names_data[seq(limit + 1, ncol(.data))]
    rhs <- rhs[which(rhs %in% not_moving)]
    new_order <- c(lhs, vars, rhs)
  } else if (where == "AFTER") {
    limit <- which(names_data == .after)
    lhs <- names_data[seq_len(limit)]
    lhs <- lhs[which(lhs %in% not_moving)]
    # we don't have RHS if we relocate columns to be in the last position
    if (identical(lhs, not_moving)) {
      rhs <- NULL
    } else {
      rhs <- names_data[seq(limit + 1, ncol(.data))]
      rhs <- rhs[which(rhs %in% not_moving)]
    }
    new_order <- c(lhs, vars, rhs)
  }

  out <- .data$select(new_order)
  add_tidypolars_class(out)
}

#' @rdname relocate.RPolarsDataFrame
#' @export
relocate.RPolarsLazyFrame <- relocate.RPolarsDataFrame
