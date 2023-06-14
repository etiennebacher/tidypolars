# All these functions should be internal, the user doesn't need to access them

pl_abs <- function(x, ...) {
  check_empty_dots(...)
  x$abs()
}

pl_mean <- function(x, ...) {
  check_empty_dots(...)
  x$mean()
}

pl_floor <- function(x, ...) {
  check_empty_dots(...)
  x$floor()
}
