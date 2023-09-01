
pl_str_contains <- function(x, ...) {
  check_empty_dots(...)
  x$str$contains()
}

pl_str_count_match <- function(x, pattern = "", ...) {
  check_empty_dots(...)
  x$str$count_match(pattern)
}

pl_str_ends <- function(x, pattern, negate = FALSE) {
  if (isTRUE(negate)) {
    x$str$ends_with(pl$lit(pattern))$is_not()
  } else {
    x$str$ends_with(pl$lit(pattern))
  }
}

pl_str_extract <- function(x, pattern, group = 0) {
  x$str$extract(pattern, group)
}

pl_str_extract_all <- function(x, ...) {
  check_empty_dots(...)
  x$str$extract_all()
}

pl_str_length <- function(x, ...) {
  check_empty_dots(...)
  x$str$n_chars()
}

pl_str_n_chars <- pl_str_length

pl_str_parse_int <- function(x, ...) {
  check_empty_dots(...)
  x$str$parse_int()
}

pl_str_replace <- function(x, pattern, replacement, ...) {
  check_empty_dots(...)
  x$str$replace(pattern, replacement)
}

pl_str_replace_all <- function(x, pattern, replacement, ...) {
  check_empty_dots(...)
  x$str$replace_all(pattern, replacement)
}

pl_str_slice <- function(x, start, end = NULL, ...) {
  check_empty_dots(...)
  # polars is 0-indexed
  if (start > 0) start <- start - 1
  x$str$slice(start, end)
}

pl_str_split <- function(x, ...) {
  check_empty_dots(...)
  x$str$split()
}

pl_str_split_exact <- function(x, ...) {
  check_empty_dots(...)
  x$str$split_exact()
}

pl_str_splitn <- function(x, ...) {
  check_empty_dots(...)
  x$str$splitn()
}

pl_str_starts <- function(x, pattern, negate = FALSE) {
  if (isTRUE(negate)) {
    x$str$starts_with(pl$lit(pattern))$is_not()
  } else {
    x$str$starts_with(pl$lit(pattern))
  }
}

pl_str_strptime <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime()
}

pl_str_to_lower <- function(x, ...) {
  check_empty_dots(...)
  x$str$to_lowercase()
}

pl_tolower <- pl_str_to_lower

pl_str_to_upper <- function(x, ...) {
  check_empty_dots(...)
  x$str$to_uppercase()
}

pl_toupper <- pl_str_to_upper

pl_str_zfill <- function(x, ...) {
  check_empty_dots(...)
  x$str$zfill()
}

# not in polars
pl_str_remove <- function(x, pattern, ...) {
  check_empty_dots(...)
  x$str$replace(pattern, "")
}

# not in polars
pl_str_remove_all <- function(x, pattern, ...) {
  check_empty_dots(...)
  x$str$replace_all(pattern, "")
}

pl_paste0 <- function(..., collapse = NULL) {
  pl$concat_str(...)
}

pl_paste <- function(..., sep = " ", collapse = NULL) {
  # TODO: hacky, I do this because specifying e.g sep = "--" gets wrapped into
  # Utf8() and doesn't work inside concat_str
  if (!is.character(sep)) {
    sep <- sep$to_r()
  }
  pl$concat_str(..., separator = sep)
}

pl_str_trim <- function(x, side = "both") {
  switch(
    side,
    "both" = x$str$strip(),
    "left" = x$str$lstrip(),
    "right" = x$str$rstrip()
  )
}

pl_str_pad <- function(x, width, side = "left", pad = " ", use_width = TRUE) {
  if (isFALSE(use_width)) {
    abort(
      '`str_pad()` doesn\'t work in a Polars DataFrame when `use_width = FALSE`',
      class = "tidypolars_error"
    )
  }
  switch(
    side,
    "both" = abort(
      '`str_pad()` doesn\'t work in a Polars DataFrame when `side = "both"`',
      class = "tidypolars_error"
    ),
    # polars and dplyr have the opposite understanding for "side"
    "left" = x$str$rjust(width = width, fillchar = pad),
    "right" = x$str$ljust(width = width, fillchar = pad)
  )
}

# not in polars

pl_word <- function(string, start = 1L, end = start, sep = " ") {
  string$str$split(sep)$arr$take((start:end) - 1L)$arr$join(sep)
}

pl_str_squish <- function(string) {
  string$str$replace_all("\\s+", " ")$str$strip()
}
