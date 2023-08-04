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
#' @examples
#' pl_iris <- polars::pl$DataFrame(iris)
#'
#' pl_filter(pl_iris, Sepal.Length < 5 & Species == "setosa")
#'
#' pl_filter(pl_iris, Sepal.Length < Sepal.Width + Petal.Length)
#'
#' pl_filter(pl_iris, Species == "setosa" | is.na(Species))
#'
#' pl_filter(pl_iris, between(Sepal.Length, 5, 6, include_bounds = FALSE))
#'
#' iris2 <- iris
#' iris2$Species <- as.character(iris2$Species)
#' iris2 |>
#'   as_polars() |>
#'   pl_filter(Species %in% c("setosa", "virginica"))
#'

pl_filter <- function(.data, ...) {

  check_polars_data(.data)
  dots <- get_dots(...)

  expr <- rearrange_exprs(.data, dots, create_new = FALSE)[[2]] |>
    unlist()

  expr <- parse_boolean_exprs(expr)

  # the code for grouped data uses $over() inside $filter(), which
  # cannot be used with grouped data. Therefore I have to manually ungroup
  # the data
  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  if (is_grouped) {
    expr <- paste0("(", expr, ")$over(grps)")
  }

  expr <- str2lang(expr)
  out <- .data$filter(eval(expr))
  attr(out, "maintain_grp_order") <- mo
  attr(out, "pl_grps") <- grps
  out
}
