#' Complete a data frame with missing combinations of data
#'
#' Turns implicit missing values into explicit missing values. This is useful
#' for completing missing combinations of data. Note that this function doesn't
#' work with grouped data yet.
#'
#' @param data A Polars Data/LazyFrame
#' @inheritParams pl_select
#'
#' @export
#' @examplesIf packageVersion("polars") >= "0.6.2"
#' test <- polars::pl$DataFrame(
#'   country = c("France", "France", "UK", "UK", "Spain"),
#'   year = c(2020, 2021, 2019, 2020, 2022),
#'   value = c(1, 2, 3, 4, 5)
#' )
#' test
#'
#' pl_complete(test, country, year)

pl_complete <- function(data, ...) {

  check_polars_data(data)

  dots <- .select_nse_from_dots(data, ...)
  left <- list()
  for (i in seq_along(dots)) {
    if (i == 1) {
      left[[1]] <- data$select(dots[i])$unique()
    } else {
      left[[1]] <- left[[1]]$join(
        data$select(dots[i])$unique(),
        how = 'cross'
      )$unique()
    }
  }

  left[[1]]$join(data, how='left', on = dots)$sort(dots)
}
