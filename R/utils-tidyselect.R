tidyselect_dots <- function(.data, ..., with_renaming = FALSE) {
  data <- build_data_context(.data)
  check_where_arg(...)
  out <- tidyselect::eval_select(
    rlang::expr(c(...)),
    data,
    error_call = caller_env()
  )
  if (length(out) == 0) {
    return(NULL)
  }
  if (isTRUE(with_renaming)) {
    return(out)
  }
  names(out)
}

tidyselect_named_arg <- function(.data, cols) {
  data <- build_data_context(.data)
  out <- names(
    tidyselect::eval_select(cols, data = data, error_call = caller_env())
  )
  if (length(out) == 0) {
    return(NULL)
  }
  out
}

# This is used only in across() when we need to determine whether variables
# created in previous calls should be included in the .cols argument. Since we
# don't have sequential evaluation, we can't use where().
tidyselect_new_vars <- function(.cols, new_vars) {
  if (is.null(new_vars)) {
    return(NULL)
  }
  if (typeof(.cols) == "language") {
    out <- switch(
      as.character(.cols[[1]]),
      "contains" = grep(.cols[[2]], new_vars, value = TRUE, fixed = TRUE),
      "matches" = grep(.cols[[2]], new_vars, value = TRUE),
      "starts_with" = grep(paste0("^", .cols[[2]]), new_vars, value = TRUE),
      "ends_with" = grep(paste0(.cols[[2]], "$"), new_vars, value = TRUE),
      "everything" = new_vars,
      {
        warn(
          paste0(
            "In `across()`, the argument `.cols = ",
            safe_deparse(.cols),
            "` will not take into account \nvariables created in the same `mutate()`/`summarize` call."
          )
        )
        NULL
      }
    )
    return(out)
  }
  NULL
}

# Rather than collecting a 1-row slice, it is faster to use the schema of the
# data to recreate an empty DataFrame and convert it to R
build_data_context <- function(.data) {
  .data$slice(offset = 0, length = 0) |>
    as_tibble()
}

#' Because the data used in selection is an empty DataFrame, where() can only
#' be used to select depending on the type of columns, not on operations (like
#' mean(), etc.)
#' @noRd
check_where_arg <- function(...) {
  exprs <- get_dots(...)
  for (i in seq_along(exprs)) {
    tmp <- safe_deparse(exprs[[i]])
    if (!startsWith(tmp, "where(")) {
      next
    }
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
