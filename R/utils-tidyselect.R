tidyselect_dots <- function(.data, ...) {
  if (inherits(.data, "LazyGroupBy")) {
    data <- .data$first()$collect()$to_data_frame()
  } else if (inherits(.data, "GroupBy")) {
    data <- .data$first()$to_data_frame()
  } else if (inherits(.data, "LazyFrame")) {
    data <- .data$first()$collect()$to_data_frame()
  } else {
    data <- .data$first()$to_data_frame()
  }
  check_where_arg(...)
  names(tidyselect::eval_select(rlang::expr(c(...)), data))
}


tidyselect_named_arg <- function(.data, cols) {
  if (inherits(.data, "LazyFrame")) {
    data <- .data$slice(1)$collect()$to_data_frame()
  } else {
    data <- .data$slice(1)$to_data_frame()
  }
  names(tidyselect::eval_select(cols, data = data))
}


#' Because the data used in selection is only a 1-row slice, where() can only
#' be used to select depending on the type of columns, not on operations (like
#' mean(), etc.)
check_where_arg <- function(...) {
  exprs <- get_dots(...)
  for (i in seq_along(exprs)) {
    tmp <- safe_deparse(exprs[[i]])
    if (!startsWith(tmp, "where(")) next
    tmp <- gsub("^where\\(", "", tmp)
    tmp <- gsub("\\)$", "", tmp)
    if (!startsWith(tmp, "is.")) {
      rlang::abort("`where()` can only take `is.*` functions (like `is.numeric`).")
    }
  }
}
