#' Rename columns
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... For `pl_rename()`, one of the following:
#' * params like `new_name = "old_name"` to rename selected variables.
#' * as above but params wrapped in a list
#'
#'  For `pl_rename_with`, additional arguments passed to `fn`.
#' @param .fn Function to apply on column names
#' @param .cols Columns on which to apply `fn`. Can be anything accepted by
#'   `dplyr::select()`.
#'
#' @rdname pl_rename
#' @export
#' @examples
#' pl_test <- polars::pl$DataFrame(mtcars)
#'
#' pl_rename(pl_test, miles_per_gallon = "mpg", horsepower = "hp")
#'
#' pl_rename(pl_test, list(miles_per_gallon = "mpg", horsepower = "hp"))
#'
#' pl_rename(pl_test, `Miles per gallon` = "mpg", `Horse power` = "hp")
#'
#' pl_rename_with(pl_test, toupper, cols = contains("p"))
#'
#' pl_test_2 <- polars::pl$DataFrame(iris)
#'
#' pl_rename_with(pl_test_2, function(x) tolower(gsub(".", "_", x, fixed = TRUE)))
#'
#' pl_rename_with(pl_test_2, \(x) tolower(gsub(".", "_", x, fixed = TRUE)))

pl_rename <- function(.data, ...) {
  check_polars_data(.data)
  .data$rename(...)
}

#' @rdname pl_rename
#' @export

pl_rename_with <- function(.data, .fn, .cols = everything(), ...) {
  check_polars_data(.data)
  to_replace <- tidyselect_named_arg(.data, rlang::enquo(.cols))
  new <- do.call(.fn, list(to_replace, ...))
  mapping <- as.list(to_replace)
  names(mapping) <- new
  .data$rename(mapping)
}
