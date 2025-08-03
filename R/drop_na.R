#' Drop missing values
#'
#' By default, this will drop rows that contain any missing values. It is
#' possible to specify a subset of variables so that only missing values in these
#' variables will be considered.
#'
#' @inheritParams fill.polars_data_frame
#' @inheritParams slice_tail.polars_data_frame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' tmp <- mtcars
#' tmp[1:3, "mpg"] <- NA
#' tmp[4, "hp"] <- NA
#' pl_tmp <- as_polars_df(tmp)
#'
#' drop_na(pl_tmp)
#' drop_na(pl_tmp, hp, mpg)

drop_na.polars_data_frame <- function(data, ...) {
  vars <- tidyselect_dots(data, ...) %||% cs$all()
  out <- data$drop_nulls(!!!c(vars))
  add_tidypolars_class(out)
}

#' @rdname drop_na.polars_data_frame
#' @export
drop_na.polars_lazy_frame <- drop_na.polars_data_frame
