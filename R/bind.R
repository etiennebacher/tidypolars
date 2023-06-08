#' @export
pl_bind_rows <- function(...) {
  concat_(..., how = "vertical")
}

#' @export
pl_bind_cols <- function(...) {
  concat_(..., how = "horizontal")
}

concat_ <- function(..., how) {
  dots <- get_dots(...)
  one_el <- length(dots) == 1L

  dots <- lapply(dots, \(x) eval(x, envir = parent.frame(4L)))
  dots_is_a_single_list <- one_el && is.list(dots)

  if (dots_is_a_single_list) dots <- unlist(dots)

  if (any(vapply(dots, \(y) !inherits(y, "DataFrame"), FUN.VALUE = logical(1L)))) {
    stop("Some elements in `...` are not a DataFrame.")
  }

  pl$concat(dots, how = how)
}

