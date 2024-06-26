#' Order rows using column values
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Quoted or unquoted variable names. Select helpers cannot be used.
#' @param .by_group If `TRUE`, will sort data within groups.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_test <- polars::pl$DataFrame(
#'   x1 = c("a", "a", "b", "a", "c"),
#'   x2 = c(2, 1, 5, 3, 1),
#'   value = sample(1:5)
#' )
#'
#' arrange(pl_test, x1)
#' arrange(pl_test, x1, -x2)
#'
#' # if the data is grouped, you need to specify `.by_group = TRUE` to sort by
#' # the groups first
#' pl_test |>
#'   group_by(x1) |>
#'   arrange(-x2, .by_group = TRUE)

arrange.RPolarsDataFrame <- function(.data, ..., .by_group = FALSE) {

  dots <- get_dots(...)
  out_length <- length(dots)
  direction <- rep(FALSE, out_length)

  grps <- attributes(.data)$pl_grps
  mo <- attributes(data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  vars <- lapply(seq_along(dots), \(x) {
      out <- as.character(dots[[x]])
      if (length(out) == 2 && out[1] %in% c("-", "desc")) {
        out <- as.character(dots[[x]][2])
        direction[x] <<- TRUE
      }
      out
    }) |>
    unlist()

  not_exist <- which(!vars %in% names(.data))
  if (length(not_exist) > 0) {
    vars <- vars[-not_exist]
    direction <- direction[-not_exist]
  }

  if (length(vars) == 0) return(.data)

  if (is_grouped && isTRUE(.by_group)) {
    vars <- c(grps, vars)
    direction <- c(rep(FALSE, length(grps)), direction)
  }

  out <- if (is_grouped) {
    .data$sort(vars, descending = direction) |>
      group_by(grps, maintain_order = mo)
  } else {
    .data$sort(vars, descending = direction)
  }

  add_tidypolars_class(out)
}

#' @export
arrange.RPolarsLazyFrame <- arrange.RPolarsDataFrame
