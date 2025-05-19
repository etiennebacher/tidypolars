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
#' `across()` is mostly supported, except in a few cases. In particular, if the
#' `.cols` argument is `where(...)`, it will *not* select variables that were
#' created before `across()`. Other select helpers are supported. See the examples.
#' @param .by Optionally, a selection of columns to group by for just this
#'   operation, functioning as an alternative to `group_by()`. The group order
#'   is not maintained, use `group_by()` if you want more control over it.
#' @param .keep Control which columns from `.data` are retained in the output.
#' Grouping columns and columns created by `...` are always kept.
#' * `"all"` retains all columns from .data. This is the default.
#' * `"used"` retains only the columns used in ... to create new columns. This is
#'   useful for checking your work, as it displays inputs and outputs side-by-
#'   side.
#' * `"unused"` retains only the columns not used in `...` to create new columns.
#'   This is useful if you generate new columns, but no longer need the columns
#'   used to generate them.
#' * `"none"` doesn't retain any extra columns from `.data`. Only the grouping
#'   variables and columns created by `...` are kept.
#'
#' @details
#'
#' A lot of functions available in base R (cos, mean, multiplying, etc.) or
#' in other packages (dplyr::lag(), etc.) are implemented in an efficient
#' way in Polars. These functions are automatically translated to Polars
#' syntax under the hood so that you can continue using the classic R syntax and
#' functions.
#'
#' If a Polars built-in replacement doesn't exist (for example for custom
#' functions), then `tidypolars` will throw an error. See the vignette on Polars
#' expressions to know how to write custom functions that are accepted by
#' `tidypolars`.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_iris <- neopolars::as_polars_df(iris)
#'
#' # classic operation
#' mutate(pl_iris, x = Sepal.Width + Sepal.Length)
#'
#' # logical operation
#' mutate(pl_iris, x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length)
#'
#' # overwrite existing variable
#' mutate(pl_iris, Sepal.Width = Sepal.Width * 2)
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
#' #
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
#' # Be careful when using across(.cols = where(...), ...) as it will not include
#' # variables created in the same `...` (this is only the case for `where()`):
#' \dontrun{
#' pl_iris |>
#'   mutate(
#'     foo = 1,
#'     across(
#'       .cols = where(is.numeric),
#'       \(x) x - 1000 # <<<<<<<<< this will not be applied on variable "foo"
#'     )
#'   )
#' }
#' # Warning message:
#' # In `across()`, the argument `.cols = where(is.numeric)` will not take into account
#' # variables created in the same `mutate()`/`summarize` call.
#'
#' # Embracing an external variable works
#' some_value <- 1
#' mutate(pl_iris, x = {{ some_value }})
mutate.polars_data_frame <- function(
  .data,
  ...,
  .by = NULL,
  .keep = c("all", "used", "unused", "none")
) {
  .keep <- rlang::arg_match0(.keep, values = c("all", "used", "unused", "none"))

  grps <- get_grps(.data, rlang::enquo(.by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)
  is_rowwise <- attributes(.data)$grp_type == "rowwise"
  to_drop <- list()

  polars_exprs <- translate_dots(
    .data = .data,
    ...,
    env = rlang::current_env(),
    caller = rlang::caller_env()
  )

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
        sub <- lapply(sub, \(x) {
          order_by <- attributes(x)[["order_by"]]
          if (!is.null(order_by)) {
            if (!is.list(order_by)) {
              order_by <- list(order_by)
            }
            x$over(!!!grps, order_by = order_by)
          } else {
            x$over(!!!grps)
          }
        })
      }
      .data <- .data$with_columns(!!!sub)
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

  out <- if (is_grouped && missing(.by)) {
    group_by(.data, all_of(grps), maintain_order = mo)
  } else if (isTRUE(is_rowwise)) {
    rowwise(.data)
  } else {
    .data
  }

  add_tidypolars_class(out)
}

#' @rdname mutate.polars_data_frame
#' @export
mutate.polars_lazy_frame <- mutate.polars_data_frame
