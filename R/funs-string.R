
pl_str_detect <- function(string, pattern, negate = FALSE) {
  out <- string$str$contains(pattern)
  if (isTRUE(negate)) {
    out$is_not()
  } else {
    out
  }
}

pl_grepl <- function(pattern, x, ...) {
  check_empty_dots(...)
  pl_str_detect(string = x, pattern = pattern)
}

pl_str_count_match <- function(string, pattern = "", ...) {
  check_empty_dots(...)
  # TODO: use literal = is_fixed when str_count_match has an arg "literal" in
  # py-polars
  # https://github.com/pola-rs/polars/issues/10930
  is_fixed <- isTRUE(attr(pattern, "stringr_attr") == "fixed")
  string$str$count_match(pattern)
}

pl_str_ends <- function(string, pattern, negate = FALSE) {
  out <- string$str$ends_with(pattern)
  if (isTRUE(negate)) {
    out$is_not()
  } else {
    out
  }
}

# group = 0 means the whole match
pl_str_extract <- function(string, pattern, group = 0) {
  string$str$extract(pattern, group_index = group)
}

# TODO: argument "simplify" should be allowed. It requirest the method "unnest"
# for "struct". When it is implement in r-polars, use this:
# $arr$to_struct()$struct$unnest()
pl_str_extract_all <- function(string, pattern, ...) {
  check_empty_dots(...)
  string$str$extract_all(pattern)
}

pl_str_length <- function(string, ...) {
  check_empty_dots(...)
  string$str$n_chars()
}

pl_str_n_chars <- pl_str_length

pl_str_replace <- function(string, pattern, replacement, ...) {
  check_empty_dots(...)
  string$str$replace(pattern, replacement)
}

pl_str_replace_all <- function(string, pattern, replacement, ...) {
  check_empty_dots(...)
  string$str$replace_all(pattern, replacement)
}

pl_str_slice <- function(string, start, end = NULL, ...) {
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

pl_str_starts <- function(string, pattern, negate = FALSE) {
  if (isTRUE(negate)) {
    string$str$starts_with(pl$lit(pattern))$is_not()
  } else {
    string$str$starts_with(pl$lit(pattern))
  }
}

pl_str_strptime <- function(string, ...) {
  check_empty_dots(...)
  string$str$strptime()
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
  if (isFALSE(polars::pl$polars_info()$features$full_features)) {
    rlang::abort(
      c("You can only use `str_to_title()` or `toTitleCase()` when polars was compiled with the\n  RPOLARS_FULL_FEATURES envvar enabled.",
        "Your version of polars was not. Try to install polars from Github releases (see \n  https://rpolars.github.io/#github-releases)."),
      class = "tidypolars_error"
    )
  }
  check_empty_dots(...)
  string$str$to_titlecase()
}
pl_toTitleCase <- pl_str_to_title

# not in polars
pl_str_remove <- function(string, pattern, ...) {
  check_empty_dots(...)
  string$str$replace(pattern, "")
}

# not in polars
pl_str_remove_all <- function(string, pattern, ...) {
  check_empty_dots(...)
  string$str$replace_all(pattern, "")
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

pl_str_trim <- function(string, side = "both") {
  switch(
    side,
    "both" = string$str$strip(),
    "left" = string$str$lstrip(),
    "right" = string$str$rstrip()
  )
}

pl_trimws <- function(string, which = "both", ...) {
  check_empty_dots(...)
  pl_str_trim(string, side = which)
}

pl_str_pad <- function(string, width, side = "left", pad = " ", use_width = TRUE) {
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
    "left" = string$str$rjust(width = width, fillchar = pad),
    "right" = string$str$ljust(width = width, fillchar = pad)
  )
}

# not in polars

pl_word <- function(string, start = 1L, end = start, sep = " ") {
  string$str$split(sep)$arr$take((start:end) - 1L)$arr$join(sep)
}

pl_str_squish <- function(string) {
  string$str$replace_all("\\s+", " ")$str$strip()
}
