pl_as.numeric <- function(x, ...) {
  check_empty_dots(...)
  x$cast(polars::pl$Float64, strict = FALSE)
}

# This one has strict = TRUE because R converts "1.5" (character) to 1 (int)
# while polars returns null.
pl_as.integer <- function(x, ...) {
  check_empty_dots(...)
  x$cast(polars::pl$Int32, strict = TRUE)
}

pl_as.logical <- function(x, ...) {
  check_empty_dots(...)
  x$cast(polars::pl$Boolean, strict = FALSE)
}

pl_as.character <- function(x, ...) {
  check_empty_dots(...)
  x$cast(polars::pl$String, strict = FALSE)
}

pl_as.Date <- function(x, format, ...) {
  check_empty_dots(...)
  if (missing(format)) {
    format <- NULL
  } else {
    format <- polars_expr_to_r(format)
  }
  if (length(format) > 1) {
    cli_abort("{.pkg tidypolars} only supports `format` of length 1.")
  }
  # TODO: shouldn't be needed
  if (is.character(x)) {
    x <- pl$lit(x)
  }
  x$str$strptime(pl$Date, format = format, strict = FALSE)
}
