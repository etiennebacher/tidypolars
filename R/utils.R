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

# mostly to make R CMD check happy about S3 consistency
unused_args <- function(...) {
  x <- get_dots(...)
  unused <- c()
  for (i in seq_along(x)) {
    if (!is.null(eval(x[[i]], parent.frame(1L)))) {
      unused <- c(unused, deparse(x[[i]]))
    }
  }
  if (length(unused) == 0) {
    return(invisible())
  }
  warn(
    paste("Unused arguments:", toString(unused)),
    call = caller_env(2)
  )
}

get_grps <- function(.data, .by, env) {
  grps <- attributes(.data)$pl_grps
  inline_grps <- tidyselect_named_arg(.data, .by)
  if (length(inline_grps) > 0) {
    if (!is.null(grps)) {
      abort(
        "Can't supply `.by` when `.data` is a grouped DataFrame or LazyFrame.",
        call = env
      )
    } else {
      grps <- inline_grps
    }
  }
  grps
}

`%||%` <- function(x, y) {
  if (is_null(x)) y else x
}
