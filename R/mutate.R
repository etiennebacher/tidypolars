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
#' @param .by Optionally, a selection of columns to group by for just this
#'   operation, functioning as an alternative to `group_by()`. The group order
#'   is not maintained, use `group_by()` if you want more control over it.
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
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_iris <- polars::pl$DataFrame(iris)
#'
#' # classic operation
#' mutate(pl_iris, x = Sepal.Width + Sepal.Length)
#'
#' # logical operation
#' mutate(pl_iris, x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length)
#'
#' # overwrite existing variable
#' mutate(pl_iris, Sepal.Width = Sepal.Width*2)
#'
#' # grouped computation
#' pl_iris |>
#'   group_by(Species) |>
#'   mutate(foo = mean(Sepal.Length))
#'
#' # an alternative syntax for grouping is to use `.by`
#' pl_iris |>
#'   mutate(foo = mean(Sepal.Length), .by = Species)
#'
#' # across() is available
#' pl_iris |>
#'   mutate(
#'     across(.cols = contains("Sepal"), .fns = mean, .names = "{.fn}_of_{.col}")
#'   )
#
#' # It can receive several types of functions:
#' pl_iris |>
#'   mutate(
#'     across(
#'       .cols = contains("Sepal"),
#'       .fns = list(mean = mean, sd = ~ sd(.x)),
#'       .names = "{.fn}_of_{.col}"
#'     )
#'   )
#'
#' # Embracing an external variable works
#' some_value <- 1
#' mutate(pl_iris, x = {{ some_value }})

mutate.RPolarsDataFrame <- function(
    .data,
    ...,
    .by = NULL,
    .keep = c("all", "used", "unused", "none")
  ) {

  check_polars_data(.data)
  rlang::arg_match(.keep)

  grps <- get_grps(.data, rlang::enquo(.by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)
  to_drop <- list()

  polars_exprs <- translate_dots(.data = .data, ..., env = rlang::current_env())

  used <- c()
  orig_names <- names(.data)

  for (i in seq_along(polars_exprs)) {
    sub <- polars_exprs[[i]]
    to_drop <- names(empty_elems(sub))
    sub <- compact(sub)

    used <- c(
      used,
      lapply(sub, \(x) x$meta$root_names()) |>
        unlist() |>
        unique()
    )

    if (length(sub) > 0) {
      if (is_grouped) {
        sub <- lapply(sub, \(x) x$over(grps))
      }
      .data <- .data$with_columns(sub)
    }

    if (length(to_drop) > 0) {
      .data <- .data$drop(to_drop)
    }
  }

  if (.keep != "all") {
    new_vars <- setdiff(names(.data), orig_names)
    not_used <- setdiff(orig_names, used)
    not_used <- setdiff(not_used, grps)
    if (.keep == "used") {
      .data <- .data$drop(not_used)
    } else if (.keep == "unused") {
      .data <- .data$drop(used)
    } else if (.keep == "none") {
      .data <- .data$drop(c(not_used, used))
    }
  }

  if (is_grouped && missing(.by)) {
    group_by(.data, grps, maintain_order = mo)
  } else {
    .data
  }
}

#' @rdname mutate.RPolarsDataFrame
#' @export
mutate.RPolarsLazyFrame <- mutate.RPolarsDataFrame
