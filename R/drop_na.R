#' Drop missing values
#'
#' By default, this will drop rows that contain any missing values. It is
#' possible to specify a subset of variables so that only missing values in these
#' variables will be considered.
#'
#' @inheritParams select.DataFrame
#' @inheritParams slice_tail.DataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' tmp <- mtcars
#' tmp[1:3, "mpg"] <- NA
#' tmp[4, "hp"] <- NA
#' pl_tmp <- polars::pl$DataFrame(tmp)
#'
#' drop_na(pl_tmp)
#' drop_na(pl_tmp, hp, mpg)

drop_na.DataFrame <- function(data, ...) {
  check_polars_data(data)
  vars <- tidyselect_dots(data, ...)
  data$drop_nulls(vars)
}

#' @export
drop_na.LazyFrame <- drop_na.DataFrame
