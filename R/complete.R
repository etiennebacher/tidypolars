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

  dots <- .select_nse_from_dots(.data, ...)
  if (length(dots) < 2) return(.data)

  # TODO: remove this ifelse at some point
  if (utils::packageVersion("polars") >= "0.8.0") {

    start <- ".data$select(pl$col(dots)$unique()$sort()$implode())"
    chain <- vector("list", length = length(dots) - 1)

    for (i in 1:length(dots)) {
      chain[[i]] <- paste0("$explode(dots[", i, "])")
    }

    paste0(
      start, paste(unlist(chain), collapse = ""),
      "$join(.data, on = dots, how = 'left')"
    ) |>
      str2lang() |>
      eval()

  } else {

    start <- ".data$select(dots[1])$unique()"
    chain <- vector("list", length = length(dots) - 1)

    for (i in 2:length(dots)) {
      chain[[i]] <- paste0("$join(.data$select(dots[", i, "])$unique(), how = 'cross')")
    }

    paste0(
      start, paste(unlist(chain), collapse = ""),
      "$sort(dots)$join(.data, on = dots, how = 'left')"
    ) |>
      str2lang() |>
      eval()
  }
}
