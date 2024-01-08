#' Keep rows that match a condition
#'
#' This function is used to subset a data frame, retaining all rows that satisfy
#' your conditions. To be retained, the row must produce a value of TRUE for all
#' conditions. Note that when a condition evaluates to NA the row will be
#' dropped, unlike base subsetting with `[`.
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Expressions that return a logical value, and are defined in terms
#' of the variables in the data. If multiple expressions are included, they
#' will be combined with the & operator. Only rows for which all conditions
#' evaluate to `TRUE` are kept.
#' @inheritParams mutate.RPolarsDataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_iris <- polars::pl$DataFrame(iris)
#'
#' filter(pl_iris, Sepal.Length < 5, Species == "setosa")
#'
#' filter(pl_iris, Sepal.Length < Sepal.Width + Petal.Length)
#'
#' filter(pl_iris, Species == "setosa" | is.na(Species))
#'
#' filter(pl_iris, between(Sepal.Length, 5, 6, include_bounds = FALSE))
#'
#' iris2 <- iris
#' iris2$Species <- as.character(iris2$Species)
#' iris2 |>
#'   as_polars_df() |>
#'   filter(Species %in% c("setosa", "virginica"))
#'
#' # filter by group
#' pl_iris |>
#'   group_by(Species) |>
#'   filter(Sepal.Length == max(Sepal.Length)) |>
#'   ungroup()
#'
#' # an alternative syntax for grouping is to use `.by`
#' pl_iris |>
#'   filter(Sepal.Length == max(Sepal.Length), .by = Species)

filter.RPolarsDataFrame <- function(.data, ..., .by = NULL) {
  check_polars_data(.data)

  grps <- get_grps(.data, rlang::enquo(.by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  polars_exprs <- translate_dots(.data, ..., env = rlang::current_env())

  if (is_grouped) {
    polars_exprs <- lapply(polars_exprs, \(x) x$over(grps))
  }

  # this is only applied between expressions that were separated by a comma
  # in the filter() call. So it won't replace the "|" call.
  polars_exprs <- Reduce(`&`, polars_exprs)

  tryCatch(
    {
      out <- .data$filter(polars_exprs)
    },
    error = function(e) {
      if (inherits(e, "RPolarsErr_error") &&
          grepl("string caches don't match", e$message)) {
        rlang::abort(
          c(
            "Comparing factor variables to strings is only possible when the string cache is enabled.",
            "i" = "One solution is to convert the factor variable to a character variable.",
            "i" = "Another solution is to enable the string cache, either with `pl$enable_string_cache()` or with `as_polars(with_string_cache = TRUE)`."
          ),
          call = caller_env(4)
        )
      } else {
        rlang::abort(
          e$message,
          call = caller_env(4)
        )
      }
    }
  )
  if (is_grouped && missing(.by)) {
    group_by(out, grps, maintain_order = mo)
  } else {
    out
  }
}

#' @rdname filter.RPolarsDataFrame
#' @export
filter.RPolarsLazyFrame <- filter.RPolarsDataFrame
