tidyselect_dots <- function(.data, ..., with_renaming = FALSE) {
  check_where_arg(...)
  data <- build_data_context(.data, ...)
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
  data <- build_data_context(.data, cols = cols)
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
        cli_warn(
          paste0(
            "In {.fn across}, the argument `.cols = ",
            safe_deparse(.cols),
            "` will not take into account \nvariables created in the same {.fn mutate} / {.fn summarize} call."
          )
        )
        NULL
      }
    )
    return(out)
  }
  NULL
}

# When where() is in the dots, then we need to know the type of each variable.
# This is done by creating a one-row DataFrame with the existing schema and
# convert it to a tibble.
#
# This is very expensive when there are hundreds or thousands of columns, so
# we only do it when there's a where() call.
build_data_context <- function(.data, ..., cols = NULL) {
  dots <- enexprs(...)

  # This is hit from expand_across().
  if (!is.null(cols) && !is.null(quo_get_expr(cols))) {
    dots <- append(dots, quo_get_expr(cols))
  }
  any_is_where <- any(
    vapply(
      dots,
      function(x) is_call(x, "where"),
      FUN.VALUE = logical(1)
    )
  )

  if (!any_is_where) {
    out <- rlang::set_names(
      data.frame(matrix(ncol = length(names(.data)), nrow = 0)),
      names(.data)
    )
    return(out)
  } else {
    if (ncol(.data) > 1000) {
      return(.data$head(1)$collect()$to_data_frame())
    } else {
      schema <- .data$schema
      dat <- rep(list(NA), length(schema))
      names(dat) <- names(schema)
      return(pl$DataFrame(dat)$cast(as.list(schema))$to_data_frame())
    }
  }
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
      cli_abort(
        "{.fn where} can only take {.fn is.*} functions (like {.fn is.numeric}).",
        call = caller_env(2)
      )
    }
  }
}
