#' Change column order
#'
#' Use `pl_relocate()` to change column positions, using the same syntax as
#' `pl_select()` to make it easy to move blocks of columns at once.
#'
#' @inheritParams pl_select
#' @param .before,.after Column name (either quoted or unquoted) that
#' indicates the destination of columns selected by `...`. Supplying neither
#' will move columns to the left-hand side; specifying both is an error.
#'
#' @export
#' @examples
#' dat <- as_polars(mtcars)
#'
#' dat |>
#'   pl_relocate(hp, vs, .before = cyl)
#'
#' # if .before and .after are not specified, selected columns are moved to the
#' # first positions
#' dat |>
#'   pl_relocate(hp, vs)
#'
#' # .before and .after can be quoted or unquoted
#' dat |>
#'   pl_relocate(hp, vs, .after = "gear")
#'
#' # select helpers are also available
#' dat |>
#'   pl_relocate(contains("[aeiou]"))

pl_relocate <- function(.data, ..., .before = NULL, .after = NULL) {
  check_polars_data(.data)

  if (!missing(.before) && !missing(.after)) {
    stop("You can specify either `.before` or `.after` but not both.")
  }

  names_data <- pl_colnames(.data)

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
  if (length(vars) == 0) return(.data)

  not_moving <- setdiff(names_data, vars)

  if (where == "BEFORE") {
    limit <- which(names_data == .before) - 1
    if (length(limit) == 0) {
      stop("The column specified in `.before` doesn't exist in the dataset.")
    }
    lhs <- names_data[seq_len(limit)]
    lhs <- lhs[which(lhs %in% not_moving)]
    rhs <- names_data[seq(limit + 1, ncol(.data))]
    rhs <- rhs[which(rhs %in% not_moving)]
    new_order <- c(lhs, vars, rhs)
  } else if (where == "AFTER") {
    limit <- which(names_data == .after)
    if (length(limit) == 0) {
      stop("The column specified in `.after` doesn't exist in the dataset.")
    }
    lhs <- names_data[seq_len(limit)]
    lhs <- lhs[which(lhs %in% not_moving)]
    rhs <- names_data[seq(limit + 1, ncol(.data))]
    rhs <- rhs[which(rhs %in% not_moving)]
    new_order <- c(lhs, vars, rhs)
  }

  .data$select(new_order)
}

