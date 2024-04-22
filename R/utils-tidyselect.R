tidyselect_dots <- function(.data, ...) {
  data <- build_data_context(.data)
  check_where_arg(...)
  out <- names(tidyselect::eval_select(rlang::expr(c(...)), data, error_call = caller_env()))
  if (length(out) == 0) {
    NULL
  } else {
    out
  }
}

tidyselect_named_arg <- function(.data, cols) {
  data <- build_data_context(.data)
  out <- names(tidyselect::eval_select(cols, data = data, error_call = caller_env()))
  if (length(out) == 0) return(NULL)
  out
}

# Rather than collecting a 1-row slice, it is faster to use the schema of the
# data to recreate an empty DataFrame and convert it to R
build_data_context <- function(.data) {
  schema <- .data$schema
  dat <- rep(list(NULL), length(schema))
  names(dat) <- names(schema)
  pl$DataFrame(dat, schema = schema)$to_data_frame()
}


#' Because the data used in selection is an empty DataFrame, where() can only
#' be used to select depending on the type of columns, not on operations (like
#' mean(), etc.)
#' @noRd
check_where_arg <- function(...) {
  exprs <- get_dots(...)
  for (i in seq_along(exprs)) {
    tmp <- safe_deparse(exprs[[i]])
    if (!startsWith(tmp, "where(")) next
    tmp <- gsub("^where\\(", "", tmp)
    tmp <- gsub("\\)$", "", tmp)
    if (!startsWith(tmp, "is.")) {
      rlang::abort(
        "`where()` can only take `is.*` functions (like `is.numeric`).",
        call = caller_env(2)
      )
    }
  }
}
