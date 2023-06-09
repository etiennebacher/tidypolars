#' Create, modify, and delete columns
#'
#' This creates new columns that are functions of existing variables. It
#' can also modify (if the name is the same as an existing column) and
#' delete columns (by setting their value to NULL).
#'
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Name-value pairs. The name gives the name of the column in
#'   the output. The value can be:
#'   * A vector the same length as the current group (or the whole data
#'    frame if ungrouped).
#'   * NULL, to remove the column.
#'
#' @details
#'
#' A lot of functions available in base R (cos, sin, multiplying, etc.) or
#' in other packages (dplyr::lag(), etc.) are implemented in an efficient
#' way in Polars. These functions will be automatically translated to Polars
#' syntax under the hood so that you can continue using the classic R syntax and
#' functions.
#'
#' If a Polars built-in replacement doesn't exist (for example for custom
#' functions), the R function will be passed to `map()` in the Polars workflow.
#' Note that this is slower than using functions that can be translated to
#' Polars syntax.
#'
#' @export
#' @examples
#' pl_iris <- polars::pl$DataFrame(iris)
#'
#' # classic operation
#' pl_mutate(pl_iris, x = Sepal.Width + Sepal.Length)
#'
#' # logical operation
#' pl_mutate(pl_iris, x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length)
#'
#' # overwrite existing variable
#' pl_mutate(pl_iris, Sepal.Width = Sepal.Width*2)
#'
#' # grouped computation
#' pl_iris |>
#'   pl_group_by(Species) |>
#'   pl_mutate(
#'     foo = mean(Sepal.Length)
#'   )


pl_mutate <- function(.data, ...) {

  check_polars_data(.data)

  dots <- get_dots(...)
  out_exprs <- rearrange_exprs(.data, dots)
  to_drop <- names(out_exprs[[1]])

  out_exprs <- Filter(Negate(is.null), out_exprs[[2]])
  out_exprs <- unlist(out_exprs)
  out_exprs <- paste(out_exprs, collapse = ", ")

  if (inherits(.data, "GroupBy") || inherits(.data, "LazyGroupBy")) {
    grps <- paste0("'", pl_groups(.data), "'")
    grps <- paste(grps, collapse = ", ")
    if (inherits(.data, "GroupBy")) {
      class(.data) <- "DataFrame"
    } else if (inherits(.data, "LazyGroupBy")) {
      class(.data) <- "LazyFrame"
    }

    out_exprs <- paste0(out_exprs, "$over(", eval(grps), ")")
    out_expr <- paste0(".data$with_columns(", out_exprs, ")$groupby(", grps, ")")
  } else {
    out_expr <- paste0(".data$with_columns(", out_exprs, ")")
  }

  out <- out_expr |>
    str2lang() |>
    eval()

  if (length(to_drop) > 0) {
    out$drop(eval(to_drop))
  } else {
    out
  }
}
