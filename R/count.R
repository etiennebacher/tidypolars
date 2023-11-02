#' Count the observations in each group
#'
#' @param x A Polars Data/LazyFrame
#' @inheritParams select.DataFrame
#' @param sort If `TRUE`, will show the largest groups at the top.
#' @param name Name of the new column.
#'
#' @export
#' @examples
#' test <- polars::pl$DataFrame(mtcars)
#' count(test, cyl)
#'
#' count(test, cyl, am)
#'
#' count(test, cyl, am, sort = TRUE, name = "count")
#'
#' add_count(test, cyl, am, sort = TRUE, name = "count")

count.DataFrame <- function(x, ..., sort = FALSE, name = "n") {
  check_polars_data(x)
  vars <- tidyselect_dots(x, ...)
  vars <- c(attributes(x)$pl_grps, vars)
  count_(x, vars, sort = sort, name = name, new_col = FALSE)
}

#' @export
count.LazyFrame <- count.DataFrame


#' @export

add_count.DataFrame <- function(x, ..., sort = FALSE, name = "n") {
  check_polars_data(x)
  vars <- tidyselect_dots(x, ...)
  vars <- c(attributes(x)$pl_grps, vars)
  count_(x, vars, sort = sort, name = name, new_col = TRUE)
}

#' @export
add_count.LazyFrame <- add_count.DataFrame

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
