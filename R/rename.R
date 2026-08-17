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
rename.polars_data_frame <- function(.data, ...) {
  .data <- tag_frame(.data, substitute(.data))
  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order %||% FALSE
  dots <- get_dots(...)
  dots <- lapply(dots, rlang::as_name)
  # polars wants a list with old names as names and new names as values
  new_names <- as.list(names(dots))
  names(new_names) <- dots
  renamed_grps <- match(grps, names(new_names))
  is_renamed <- !is.na(renamed_grps)
  grps[is_renamed] <- unlist(
    new_names[renamed_grps[is_renamed]],
    use.names = FALSE
  )
  out <- with_polars_errors(.data$rename(!!!new_names))
  if (length(grps) > 0) {
    out <- group_by(out, all_of(grps), maintain_order = mo)
  }
  add_tidypolars_class(out)
}

#' @rdname rename.polars_data_frame
#' @export
rename.polars_lazy_frame <- rename.polars_data_frame

#' @rdname rename.polars_data_frame
#' @export

rename_with.polars_data_frame <- function(
  .data,
  .fn,
  .cols = tidyselect::everything(),
  ...
) {
  .data <- tag_frame(.data, substitute(.data))
  grps <- attributes(.data)$pl_grps
  mo <- attributes(.data)$maintain_grp_order %||% FALSE
  to_replace <- tidyselect_named_arg(.data, rlang::enquo(.cols))
  new <- do.call(.fn, list(to_replace, ...))
  # polars wants a list with old names as names and new names as values
  mapping <- as.list(new)
  names(mapping) <- to_replace
  renamed_grps <- match(grps, names(mapping))
  is_renamed <- !is.na(renamed_grps)
  grps[is_renamed] <- unlist(
    mapping[renamed_grps[is_renamed]],
    use.names = FALSE
  )
  out <- with_polars_errors(.data$rename(!!!mapping))
  if (length(grps) > 0) {
    out <- group_by(out, all_of(grps), maintain_order = mo)
  }
  add_tidypolars_class(out)
}

#' @rdname rename.polars_data_frame
#' @export
rename_with.polars_lazy_frame <- rename_with.polars_data_frame
