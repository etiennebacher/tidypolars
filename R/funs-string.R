pl_grepl <- function(pattern, x, fixed = FALSE, ...) {
  if (isTRUE(fixed)) {
    attr(x, "stringr_attr") <- "fixed"
  }
  pl_str_detect(string = x, pattern = pattern, ...)
}

pl_paste0 <- function(..., collapse = NULL) {
  pl_paste(..., sep = "", collapse = collapse)
}

pl_paste <- function(..., sep = " ", collapse = NULL) {
  # pl$concat_str() doesn't support a list input, which is problematic since
  # clean_dots() has to return a list
  pl$concat_list(clean_dots(...))$list$join(separator = sep)
}

pl_str_count <- function(string, pattern = "", ...) {
  check_empty_dots(...)
  is_fixed <- isTRUE(attr(pattern, "stringr_attr") == "fixed")
  string$str$count_matches(pattern, literal = is_fixed)
}

pl_str_detect <- function(string, pattern, negate = FALSE, ...) {
  check_empty_dots(...)
  is_fixed <- isTRUE(attr(pattern, "stringr_attr") == "fixed")
  out <- string$str$contains(pattern, literal = is_fixed)
  if (isTRUE(negate)) {
    out$not()
  } else {
    out
  }
}

pl_str_ends <- function(string, pattern, negate = FALSE, ...) {
  check_empty_dots(...)
  out <- string$str$ends_with(pattern)
  if (isTRUE(negate)) {
    out$not()
  } else {
    out
  }
}

# group = 0 means the whole match
pl_str_extract <- function(string, pattern, group = 0, ...) {
  check_empty_dots(...)
  string$str$extract(pattern, group_index = group)
}

# TODO: argument "simplify" should be allowed. It requirest the method "unnest"
# for "struct". When it is implement in r-polars, use this:
# $list$to_struct()$struct$unnest()
pl_str_extract_all <- function(string, pattern, ...) {
  check_empty_dots(...)
  string$str$extract_all(pattern)
}

pl_str_length <- function(string, ...) {
  check_empty_dots(...)
  string$str$len_chars()
}

pl_nchar <- pl_str_length

pl_str_pad <- function(string, width, side = "left", pad = " ", use_width = TRUE, ...) {
  check_empty_dots(...)
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
    "left" = string$str$pad_start(width = width, fillchar = pad),
    "right" = string$str$pad_end(width = width, fillchar = pad)
  )
}

pl_str_remove <- function(string, pattern, ...) {
  check_empty_dots(...)
  string$str$replace(pattern, "")
}

pl_str_remove_all <- function(string, pattern, ...) {
  check_empty_dots(...)
  string$str$replace_all(pattern, "")
}

pl_str_replace <- function(string, pattern, replacement, ...) {
  check_empty_dots(...)
  replacement <- parse_replacement(replacement)
  string$str$replace(pattern, replacement)
}

pl_str_replace_all <- function(string, pattern, replacement, ...) {
  check_empty_dots(...)
  # named pattern means that names are patterns and values are replacements
  names_pattern <- names(pattern)
  if (!is.null(names_pattern)) {
    out <- string
    for (i in seq_along(pattern)) {
      pattern[i] <- parse_replacement(pattern[i])
      out <- out$str$replace_all(names_pattern[i], pattern[i])
    }
  } else {
    replacement <- parse_replacement(replacement)
    out <- string$str$replace_all(pattern, replacement)
  }

  out
}

pl_str_squish <- function(string, ...) {
  check_empty_dots(...)
  string$str$replace_all("\\s+", " ")$str$strip_chars()
}

pl_str_sub <- function(string, start, end = NULL, ...) {
  check_empty_dots(...)
  # polars is 0-indexed
  if (start > 0) start <- start - 1
  string$str$slice(start, end)
}

# TODO: check how to associate this with stringr::str_split() + tidyr nesting
# pl_str_split <- function(string, ...) {
#   check_empty_dots(...)
#   string$str$split()
# }
#
# pl_str_split_exact <- function(string, ...) {
#   check_empty_dots(...)
#   string$str$split_exact()
# }
#
# pl_str_splitn <- function(string, ...) {
#   check_empty_dots(...)
#   string$str$splitn()
# }

pl_str_starts <- function(string, pattern, negate = FALSE, ...) {
  check_empty_dots(...)
  if (isTRUE(negate)) {
    string$str$starts_with(pl$lit(pattern))$not()
  } else {
    string$str$starts_with(pl$lit(pattern))
  }
}

pl_str_to_lower <- function(string, ...) {
  check_empty_dots(...)
  string$str$to_lowercase()
}
pl_tolower <- pl_str_to_lower

pl_str_to_upper <- function(string, ...) {
  check_empty_dots(...)
  string$str$to_uppercase()
}
pl_toupper <- pl_str_to_upper


pl_str_to_title <- function(string, ...) {
  check_empty_dots(...)
  string$str$to_titlecase()
}
pl_toTitleCase <- pl_str_to_title

pl_str_trim <- function(string, side = "both", ...) {
  check_empty_dots(...)
  switch(
    side,
    "both" = string$str$strip_chars(),
    "left" = string$str$strip_chars_start(),
    "right" = string$str$strip_chars_end()
  )
}

pl_trimws <- function(string, which = "both", ...) {
  check_empty_dots(...)
  pl_str_trim(string, side = which)
}

pl_word <- function(string, start = 1L, end = start, sep = " ", ...) {
  check_empty_dots(...)
  string$str$split(sep)$list$gather((start:end) - 1L)$list$join(sep)
}
