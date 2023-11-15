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
#'   as_polars() |>
#'   filter(Species %in% c("setosa", "virginica"))
#'

filter.DataFrame <- function(.data, ...) {
  check_polars_data(.data)

  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  polars_exprs <- translate_dots(.data, ..., env = rlang::current_env())

  if (is_grouped) {
    polars_exprs <- lapply(polars_exprs, \(x) x$over(grps))
  }

  # this is only applied between expressions that were separated by a comma
  # in the filter() call. So it won't replace the "|" call.
  polars_exprs <- Reduce(`&`, polars_exprs)

  out <- .data$filter(polars_exprs)
  attr(out, "maintain_grp_order") <- mo
  attr(out, "pl_grps") <- grps
  out
}

#' @rdname filter.DataFrame
#' @export
filter.LazyFrame <- filter.DataFrame
