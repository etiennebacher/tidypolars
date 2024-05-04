pl_as.numeric <- function(x, ...) {
  check_empty_dots(...)
  x$cast(polars::pl$Float64, strict = FALSE)
}

# Would require https://github.com/pola-rs/polars/issues/4982
# pl_is.numeric <- function(x) {
#
# }

pl_as.logical <- function(x, ...) {
  check_empty_dots(...)
  x$cast(polars::pl$Boolean, strict = FALSE)
}

pl_as.character <- function(x, ...) {
  check_empty_dots(...)
  x$cast(polars::pl$Utf8, strict = FALSE)
}
