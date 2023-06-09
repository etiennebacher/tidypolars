#' Count the observations in each group
#'
#' @param .data A Polars Data/LazyFrame
#' @inheritParams pl_select
#' @param sort If `TRUE`, will show the largest groups at the top.
#' @param name Name of the new column.
#'
#' @export
#' @examplesIf utils::packageVersion("polars") >= "0.6.2"
#' test <- polars::pl$DataFrame(mtcars)
#' pl_count(test, cyl)
#'
#' pl_count(test, cyl, am)
#'
#' pl_count(test, cyl, am, sort = TRUE, name = "count")
#'
#' pl_add_count(test, cyl, am, sort = TRUE, name = "count")

pl_count <- function(.data, ..., sort = FALSE, name = "n") {
  check_polars_data(.data)
  vars <- .select_nse_from_dots(.data, ...)
  count_(.data, vars, sort = sort, name = name, new_col = FALSE)
}


#' @rdname pl_count
#' @export

pl_add_count <- function(.data, ..., sort = FALSE, name = "n") {
  check_polars_data(.data)
  vars <- .select_nse_from_dots(.data, ...)
  count_(.data, vars, sort = sort, name = name, new_col = TRUE)
}

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
      out <- .data$groupby(vars, maintain_order = TRUE)$agg(
        pl$count()$alias(name)
      )
    }
  }

  if (isTRUE(sort)) {
    out <- out$sort(name, descending = TRUE)
  } else {
    out <- out$sort(vars)
  }

  out
}
