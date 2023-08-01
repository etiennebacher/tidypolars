#' Complete a data frame with missing combinations of data
#'
#' Turns implicit missing values into explicit missing values. This is useful
#' for completing missing combinations of data. Note that this function doesn't
#' work with grouped data yet.
#'
#' @param .data A Polars Data/LazyFrame
#' @inheritParams pl_select
#'
#' @export
#' @examples
#' test <- polars::pl$DataFrame(
#'   country = c("France", "France", "UK", "UK", "Spain"),
#'   year = c(2020, 2021, 2019, 2020, 2022),
#'   value = c(1, 2, 3, 4, 5)
#' )
#' test
#'
#' pl_complete(test, country, year)

pl_complete <- function(.data, ...) {

  check_polars_data(.data)

  vars <- tidyselect_dots(.data, ...)
  if (length(vars) < 2) return(.data)

  # TODO: remove this ifelse at some point
  if (utils::packageVersion("polars") > "0.7.0") {

    start <- ".data$select(pl$col(vars)$unique()$sort()$implode())"
    chain <- vector("list", length = length(vars) - 1)

    for (i in 1:length(vars)) {
      chain[[i]] <- paste0("$explode(vars[", i, "])")
    }

    paste0(
      start, paste(unlist(chain), collapse = ""),
      "$join(.data, on = vars, how = 'left')"
    ) |>
      str2lang() |>
      eval()

  } else {

    start <- ".data$select(vars[1])$unique()"
    chain <- vector("list", length = length(vars) - 1)

    for (i in 2:length(vars)) {
      chain[[i]] <- paste0("$join(.data$select(vars[", i, "])$unique(), how = 'cross')")
    }

    paste0(
      start, paste(unlist(chain), collapse = ""),
      "$sort(vars)$join(.data, on = vars, how = 'left')"
    ) |>
      str2lang() |>
      eval()
  }
}
