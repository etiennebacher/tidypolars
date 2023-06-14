# All these functions should be internal, the user doesn't need to access them

pl_abs <- function(x, ...) {
  check_empty_dots(...)
  x$abs()
}

pl_mean <- function(x, ...) {
  check_empty_dots(...)
  x$mean()
}

pl_median <- function(x, ...) {
  check_empty_dots(...)
  x$median()
}

pl_min <- function(x, ...) {
  check_empty_dots(...)
  x$min()
}

pl_max <- function(x, ...) {
  check_empty_dots(...)
  x$max()
}

pl_sum <- function(x, ...) {
  check_empty_dots(...)
  x$sum()
}

# polars std has a ddof arg but not R sd (which always uses ddof = 1)
# TODO: check whether ddof is used in dots
pl_sd <- function(x, ...) {
  check_empty_dots(...)
  x$std()
}

pl_floor <- function(x, ...) {
  check_empty_dots(...)
  x$floor()
}
