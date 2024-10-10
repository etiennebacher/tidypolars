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
  grps <- get_grps(.data, rlang::enquo(.by), env = rlang::current_env())
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  polars_exprs <- translate_dots(
    .data,
    ...,
    env = rlang::current_env(),
    caller = rlang::caller_env()
  )

  if (is_grouped) {
    polars_exprs <- lapply(polars_exprs, \(x) x$over(grps))
  }

  tryCatch(
    {
      out <- .data$filter(polars_exprs)
    },
    error = function(e) {
      rlang::abort(e$message, call = caller_env(4))
    }
  )
  out <- if (is_grouped && missing(.by)) {
    group_by(out, all_of(grps), maintain_order = mo)
  } else {
    out
  }

  out
}

#' @rdname filter.RPolarsDataFrame
#' @export
filter.RPolarsLazyFrame <- filter.RPolarsDataFrame
