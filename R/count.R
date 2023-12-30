#' Count the observations in each group
#'
#' @param x A Polars Data/LazyFrame
#' @inheritParams select.RPolarsDataFrame
#' @param sort If `TRUE`, will show the largest groups at the top.
#' @param name Name of the new column.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars::pl$DataFrame(mtcars)
#' count(test, cyl)
#'
#' count(test, cyl, am)
#'
#' count(test, cyl, am, sort = TRUE, name = "count")
#'
#' add_count(test, cyl, am, sort = TRUE, name = "count")

count.RPolarsDataFrame <- function(x, ..., sort = FALSE, name = "n") {
  check_polars_data(x)

  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order
  is_grouped <- !is.null(grps)

  vars <- tidyselect_dots(x, ...)
  vars <- c(grps, vars)
  out <- count_(x, vars, sort = sort, name = name, new_col = FALSE)

  if (is_grouped) {
    group_by(out, grps, maintain_order = mo)
  } else {
    out
  }
}

#' @rdname count.RPolarsDataFrame
#' @export
count.RPolarsLazyFrame <- count.RPolarsDataFrame

#' @rdname count.RPolarsDataFrame
#' @export

add_count.RPolarsDataFrame <- function(x, ..., sort = FALSE, name = "n") {
  check_polars_data(x)

  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order
  is_grouped <- !is.null(grps)

  vars <- tidyselect_dots(x, ...)
  vars <- c(grps, vars)
  out <- count_(x, vars, sort = sort, name = name, new_col = TRUE)

  if (is_grouped) {
    group_by(out, grps, maintain_order = mo)
  } else {
    out
  }
}

#' @rdname count.RPolarsDataFrame
#' @export
add_count.RPolarsLazyFrame <- add_count.RPolarsDataFrame

count_ <- function(x, vars, sort, name, new_col = FALSE) {

  if (isTRUE(new_col)) {
    if (length(vars) == 0) {
      out <- x$with_columns(
        pl$count()$alias(name)
      )
    } else {
      out <- x$with_columns(
        pl$count()$alias(name)$over(vars)
      )
    }
  } else {
    if (length(vars) == 0) {
      out <- x$select(
        pl$count()$alias(name)
      )
    } else {
      out <- x$group_by(vars, maintain_order = FALSE)$agg(
        pl$count()$alias(name)
      )
    }
  }

  if (isTRUE(sort)) {
    out <- out$sort(name, descending = TRUE)
  } else if (length(vars) > 0) {
    out <- out$sort(vars)
  }

  out
}
