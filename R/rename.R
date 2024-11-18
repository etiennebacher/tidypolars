#' Rename columns
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... For `rename()`, use `new_name = old_name` to rename selected
#'   variables. It is also possible to use quotation marks, e.g
#'   `"new_name" = "old_name"`.
#'
#'   For `rename_with`, additional arguments passed to `fn`.
#' @param .fn Function to apply on column names
#' @param .cols Columns on which to apply `fn`. Can be anything accepted by
#'   `dplyr::select()`.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' pl_test <- polars::as_polars_df(mtcars)
#'
#' rename(pl_test, miles_per_gallon = mpg, horsepower = "hp")
#'
#' rename(pl_test, `Miles per gallon` = "mpg", `Horse power` = "hp")
#'
#' rename_with(pl_test, toupper, .cols = contains("p"))
#'
#' pl_test_2 <- polars::as_polars_df(iris)
#'
#' rename_with(pl_test_2, function(x) tolower(gsub(".", "_", x, fixed = TRUE)))
#'
#' rename_with(pl_test_2, \(x) tolower(gsub(".", "_", x, fixed = TRUE)))
rename.RPolarsDataFrame <- function(.data, ...) {
  dots <- get_dots(...)
  dots <- lapply(dots, rlang::as_name)
  # polars wants a list with old names as names and new names as values
  new_names <- as.list(names(dots))
  names(new_names) <- dots
  out <- .data$rename(new_names)
  add_tidypolars_class(out)
}

#' @rdname rename.RPolarsDataFrame
#' @export
rename.RPolarsLazyFrame <- rename.RPolarsDataFrame

#' @rdname rename.RPolarsDataFrame
#' @export

rename_with.RPolarsDataFrame <- function(.data, .fn, .cols = tidyselect::everything(), ...) {
  to_replace <- tidyselect_named_arg(.data, rlang::enquo(.cols))
  new <- do.call(.fn, list(to_replace, ...))
  # polars wants a list with old names as names and new names as values
  mapping <- as.list(new)
  names(mapping) <- to_replace
  out <- .data$rename(mapping)
  add_tidypolars_class(out)
}

#' @rdname rename.RPolarsDataFrame
#' @export
rename_with.RPolarsLazyFrame <- rename_with.RPolarsDataFrame
