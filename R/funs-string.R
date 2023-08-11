
pl_str_concat <- function(x, ...) {
  check_empty_dots(...)
  x$str$concat()
}

pl_str_contains <- function(x, ...) {
  check_empty_dots(...)
  x$str$contains()
}

pl_str_count_match <- function(x, pattern = "", ...) {
  check_empty_dots(...)
  x$str$count_match(pattern)
}

pl_str_decode <- function(x, ...) {
  check_empty_dots(...)
  x$str$decode()
}

pl_str_encode <- function(x, ...) {
  check_empty_dots(...)
  x$str$encode()
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

pl_str_json_extract <- function(x, ...) {
  check_empty_dots(...)
  x$str$json_extract()
}

pl_str_json_path_match <- function(x, ...) {
  check_empty_dots(...)
  x$str$json_path_match()
}

pl_str_lengths <- function(x, ...) {
  check_empty_dots(...)
  x$str$lengths()
}

pl_str_ljust <- function(x, ...) {
  check_empty_dots(...)
  x$str$ljust()
}

pl_str_lstrip <- function(x, ...) {
  check_empty_dots(...)
  x$str$lstrip()
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

pl_str_rjust <- function(x, ...) {
  check_empty_dots(...)
  x$str$rjust()
}

pl_str_rstrip <- function(x, ...) {
  check_empty_dots(...)
  x$str$rstrip()
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

pl_str_str_explode <- function(x, ...) {
  check_empty_dots(...)
  x$str$str_explode()
}

pl_str_strip <- function(x, ...) {
  check_empty_dots(...)
  x$str$strip()
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
  # for (i in seq_along(dots)) {
  #   if (length(dots[[i]]) == 1 && is.character(dots[[i]])) {
  #     dots[[i]] <- pl$lit(dots[[i]])
  #   }
  # }
  pl$concat_str(...)
}
