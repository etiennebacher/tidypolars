#' Drop missing values
#'
#' By default, this will drop rows that contain any missing values. It is
#' possible to specify a subset of variables so that only missing values in these
#' variables will be considered.
#'
#' @inheritParams pl_select
#'
#' @export
#' @examples
#' tmp <- mtcars
#' tmp[1:3, "mpg"] <- NA
#' tmp[4, "hp"] <- NA
#' pl_tmp <- polars::pl$DataFrame(tmp)
#'
#' pl_drop_na(pl_tmp)
#' pl_drop_na(pl_tmp, hp, mpg)

pl_drop_na <- function(data, ...) {
  check_polars_data(data)
  vars <- .select_nse_from_dots(data, ...)
  data$drop_nulls(eval(vars))
}

#' @export
drop_na.DataFrame <- pl_drop_na
