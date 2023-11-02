#' Count the observations in each group
#'
#' @param .data A Polars Data/LazyFrame
#' @inheritParams pl_select
#' @param sort If `TRUE`, will show the largest groups at the top.
#' @param name Name of the new column.
#'
#' @rdname count
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

count.DataFrame <- function(.data, ..., sort = FALSE, name = "n") {
  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  vars <- c(attributes(.data)$pl_grps, vars)
  count_(.data, vars, sort = sort, name = name, new_col = FALSE)
}

#' @export
count.LazyFrame <- count.DataFrame


#' @rdname count
#' @export

add_count.DataFrame <- function(.data, ..., sort = FALSE, name = "n") {
  check_polars_data(.data)
  vars <- tidyselect_dots(.data, ...)
  vars <- c(attributes(.data)$pl_grps, vars)
  count_(.data, vars, sort = sort, name = name, new_col = TRUE)
}

#' @export
add_count.LazyFrame <- add_count.DataFrame

count_ <- function(.data, vars, sort, name, new_col = FALSE) {

  if (isTRUE(new_col)) {
    if (length(vars) == 0) {
      out <- .data$with_columns(
        pl$count()$alias(name)
      )
    } else {
      out <- .data$with_columns(
        pl$count()$alias(name)$over(vars)
      )
    }
  } else {
    if (length(vars) == 0) {
      out <- .data$select(
        pl$count()$alias(name)
      )
    } else {
      out <- .data$group_by(vars, maintain_order = FALSE)$agg(
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
