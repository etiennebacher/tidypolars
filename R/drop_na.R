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
  dots <- get_dots(...)

  vars <- unlist(dots)
  vars <- vars[vars %in% pl_colnames(data)]
  if (length(vars) >= 1) {
    expr <- paste0("c('", paste(dots, collapse = "', '"), "')") |>
      str2lang()
  } else {
    expr <- NULL
  }

  data$drop_nulls(eval(expr))
}

