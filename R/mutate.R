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

  grps <- attributes(.data)$pl_grps
  is_grouped <- !is.null(grps)
  to_drop <- list()

  expr <- rlang::enexprs(...)

  out <- lapply(expr, function(x) {
    res <- rlang::eval_bare(x, polars_env(x, .data))

    char_not_colname <- is.character(x) && !x %in% pl_colnames(.data)
    other_length_one <- length(x) == 1 && (is.double(x) || is.logical(x) || is.integer(x))
    if (other_length_one || char_not_colname) {
      res <- paste0("pl$lit(", x, ")")
    }
    if (is.null(res)) {
      to_drop[[names(out)[x]]] <<- 1
      return(NULL)
    }

    paste0(res, "$alias('", names(expr)[x], "')")
  })

  out <- list(to_drop = to_drop, out = out)
  to_drop <- names(out$to_drop)
  exprs <- Filter(Negate(is.null), out$out)
  out <- unlist(out$out)
  out <- paste(out, collapse = ", ")
  polars_exprs <- list(exprs = out, to_drop = to_drop)

  exprs <- polars_exprs$exprs
  to_drop <- polars_exprs$to_drop

  if (exprs != "") {
    if (is_grouped) {
      exprs <- paste0(exprs, "$over(grps)")
    }
    out <- paste0(".data$with_columns(", exprs, ")") |>
      str2lang() |>
      eval()
  } else {
    out <- .data
  }

  if (length(to_drop) > 0) {
    out$drop(to_drop)
  } else {
    out
  }
}
