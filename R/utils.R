get_dots <- function(...) {
  eval(substitute(alist(...)))
}

safe_deparse <- function (x, ...) {
  if (is.null(x)) {
    return(NULL)
  }
  paste0(sapply(deparse(x, width.cutoff = 500), trimws, simplify = TRUE),
         collapse = " ")
}

