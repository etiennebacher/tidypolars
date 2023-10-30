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

# sort of equivalent of purrr::compact()
# takes a list, returns a list
compact <- function(x) {
  Filter(\(y) length(y) != 0, x)
}

# takes a list, returns a list with only length-0 elements
empty_elems <- function(x) {
  Filter(\(y) length(y) == 0, x)
}

# take a string, replace \\1 by $1, \\2 by $2, etc.
# this is to match Polars syntax for regexes
parse_replacement <- function(x) {
  gsub("\\\\(\\d+)", "$\\1", x)
}
