pl_grepl <- function(pattern, x, ignore.case = FALSE, fixed = FALSE, ...) {
  if (isTRUE(fixed)) {
    attr(pattern, "stringr_attr") <- "fixed"
  }
  if (isTRUE(ignore.case)) {
    attr(pattern, "case_insensitive") <- TRUE
  }
  pl_str_detect_stringr(string = x, pattern = pattern, ...)
}

pl_gsub <- function(
  pattern,
  replacement,
  x,
  ignore.case = FALSE,
  fixed = FALSE,
  ...
) {
  if (isTRUE(fixed)) {
    attr(pattern, "stringr_attr") <- "fixed"
  }
  if (isTRUE(ignore.case)) {
    attr(pattern, "case_insensitive") <- TRUE
  }
  pl_str_replace_all_stringr(
    string = x,
    pattern = pattern,
    replacement = replacement,
    ...
  )
}

pl_paste0 <- function(..., collapse = NULL) {
  pl_paste(..., sep = "", collapse = collapse)
}

pl_paste <- function(..., sep = " ", collapse = NULL) {
  sep <- polars_expr_to_r(sep)
  dots <- clean_dots(...)
  check_string(sep)
  check_string(collapse, allow_null = TRUE)

  # paste(NA) -> "NA"
  dots <- lapply(seq_along(dots), function(x) {
    elem <- dots[[x]]
    if (!is_polars_expr(elem)) {
      return(elem)
    }
    elem$fill_null(pl$lit("NA"))
  })
  out <- call2(pl$concat_str, !!!dots, separator = sep) |>
    eval_bare()

  if (!is.null(collapse)) {
    out$str$join(delimiter = collapse)
  } else {
    out
  }
}

pl_str_count_stringr <- function(string, pattern = "", ...) {
  check_empty_dots(...)
  pattern <- check_pattern(pattern)
  string$str$count_matches(pattern$pattern, literal = pattern$is_fixed)
}

pl_str_detect_stringr <- function(string, pattern, negate = FALSE, ...) {
  check_empty_dots(...)
  pattern <- check_pattern(pattern)
  out <- string$str$contains(pattern$pattern, literal = pattern$is_fixed)
  if (isTRUE(negate)) {
    out$not()
  } else {
    out
  }
}

pl_str_dup_stringr <- function(string, times) {
  times <- polars_expr_to_r(times)
  if (!is_polars_expr(times)) {
    times[times < 0 | is.na(times)] <- NA
    if (length(times) == 1 && is.na(times)) {
      return(pl$lit(NA_character_))
    }
    times <- pl$lit(times)
  }
  pl$when(times$is_null() | string$is_null())$then(pl$lit(NA))$when(
    times == pl$lit(0)
  )$then(pl$lit(""))$otherwise(
    string$cast(pl$String)$repeat_by(times)$list$join("")
  )
}

pl_str_ends_stringr <- function(string, pattern, negate = FALSE, ...) {
  check_empty_dots(...)
  pattern <- check_pattern(pattern)

  # ends_with doesn't accept a regex
  # https://github.com/pola-rs/polars/issues/6778#issuecomment-1425774894
  out <- string$str$contains(paste0("(", pattern$pattern, ")$"))

  if (isTRUE(negate)) {
    out <- out$not()
  }
  out
}

pl_str_equal_stringr <- function(x, y, ...) {
  check_empty_dots(...)
  x$str$normalize("NFC") == y$str$normalize("NFC")
}


# group = 0 means the whole match
pl_str_extract_stringr <- function(string, pattern, group = 0, ...) {
  check_empty_dots(...)
  pattern <- check_pattern(pattern)
  # if pattern wasn't passed to pl$col() at this point then it must be parsed
  # as a literal otherwise extract() will error because can't find a column
  # named as pattern
  if (!is_polars_expr(pattern$pattern)) {
    pattern$pattern <- pl$lit(pattern$pattern)
  }
  string$str$extract(pattern$pattern, group_index = group)
}

# I don't support the argument "simplify" because the names of new columns
# differ depending on whether the input is a data.frame or a tibble so I don't
# know what equivalence I should target here.
pl_str_extract_all_stringr <- function(string, pattern, ...) {
  check_empty_dots(...)
  pattern <- check_pattern(pattern)
  string$str$extract_all(pattern$pattern)
}

pl_str_length_stringr <- function(string, ...) {
  check_empty_dots(...)
  string$str$len_chars()
}

pl_nchar <- pl_str_length_stringr

pl_str_pad_stringr <- function(
  string,
  width,
  side = "left",
  pad = " ",
  use_width = TRUE,
  ...
) {
  check_empty_dots(...)
  side <- polars_expr_to_r(side)
  width <- polars_expr_to_r(width)
  pad <- polars_expr_to_r(pad)

  if (isFALSE(use_width)) {
    cli_abort(
      "{.fn str_pad} doesn't work with a Polars object when {.code use_width = FALSE}",
      class = "tidypolars_error"
    )
  }

  if (length(width) > 1) {
    cli_abort(
      "{.fn str_pad} doesn't work with a Polars object when `width` has a length greater than 1.",
      class = "tidypolars_error"
    )
  }

  # follow stringr::str_pad()
  if (is.na(width) || is.na(pad)) {
    return(pl$lit(NA_character_))
  }
  if (width <= 0) {
    return(string)
  }

  switch(
    side,
    "both" = cli_abort(
      '{.fn str_pad} doesn\'t work with a Polars object when {.code side = "both"}',
      class = "tidypolars_error"
    ),
    # polars and dplyr have the opposite understanding for "side"
    "left" = string$str$pad_start(length = width, fill_char = pad),
    "right" = string$str$pad_end(length = width, fill_char = pad)
  )
}

pl_str_remove_stringr <- function(string, pattern, ...) {
  check_empty_dots(...)
  pattern <- check_pattern(pattern)
  string$str$replace(pattern$pattern, "")
}

pl_str_remove_all_stringr <- function(string, pattern, ...) {
  check_empty_dots(...)
  pattern <- check_pattern(pattern)
  string$str$replace_all(pattern$pattern, "", literal = pattern$is_fixed)
}

pl_str_replace_stringr <- function(string, pattern, replacement, ...) {
  check_empty_dots(...)
  pattern <- check_pattern(pattern)
  if (is.character(replacement)) {
    replacement <- parse_replacement(replacement)
  }
  string$str$replace(pattern$pattern, replacement, literal = pattern$is_fixed)
}

pl_str_replace_all_stringr <- function(string, pattern, replacement, ...) {
  check_empty_dots(...)
  # named pattern means that names are patterns and values are replacements
  names_pattern <- names(pattern)
  if (!is.null(names_pattern)) {
    out <- string
    for (i in seq_along(pattern)) {
      pattern[[i]] <- parse_replacement(pattern[[i]])
      out <- out$str$replace_all(names_pattern[i], pattern[[i]])
    }
  } else {
    pattern <- check_pattern(pattern)
    replacement <- parse_replacement(replacement)
    out <- string$str$replace_all(
      pattern$pattern,
      replacement,
      literal = pattern$is_fixed
    )
  }

  out
}

pl_str_squish_stringr <- function(string, ...) {
  check_empty_dots(...)
  string$str$replace_all("\\s+", " ")$str$strip_chars()
}

pl_str_starts_stringr <- function(string, pattern, negate = FALSE, ...) {
  check_empty_dots(...)
  pattern <- check_pattern(pattern)

  # starts_with doesn't accept a regex
  # https://github.com/pola-rs/polars/issues/6778#issuecomment-1425774894
  out <- string$str$contains(paste0("^(", pattern$pattern, ")"))

  if (isTRUE(negate)) {
    out <- out$not()
  }
  out
}

### Very ashamed of those two functions, would be so much better if polars
### had $str$slice(start, end) instead of $str$slice(start, length)

pl_str_sub_stringr <- function(string, start, end = NULL) {
  end_is_null <- is.null(end)
  string <- string$cast(pl$String)
  len_string <- string$str$len_chars()
  if (!is_polars_expr(start)) {
    start <- pl$lit(start)
  }
  if (!is_polars_expr(end)) {
    end <- pl$lit(end)
  }
  start <- start$cast(pl$Int64)
  end <- end$cast(pl$Int64)

  old_start <- start
  start_is_zero <- old_start == 0
  end_is_zero <- end == 0
  start <- old_start - 1
  length <- end - old_start
  length <- pl$when(length < 0)$then(pl$lit(0))$otherwise(length + 1)
  # +1 because when start = end we still want to take one character

  # I need to have something like this that is used only in a special case
  # below because polars eagerly evaluates all branches and then applies
  # them, so having length = length - 1 errors when length = 0
  foo <- pl$when(start < end & end < 0 & start$abs() <= len_string)$then(
    length
  )$otherwise(2000)

  foo2 <- pl$when(start_is_zero & end > 0 & end <= len_string)$then(
    end
  )$otherwise(2000)

  foo3 <- pl$when(start >= 0 & end_is_null)$then(len_string - start)$otherwise(
    2000
  )

  foo4 <- pl$when(start < 0 & start$abs() >= len_string & end > 0)$then(
    end
  )$otherwise(2000)

  foo5 <- pl$when(start >= 0 & end < 0 & end$abs() <= len_string)$then(
    len_string - start + end + 1
  )$otherwise(2000)

  foo6 <- pl$when(start_is_zero & end < 0 & end$abs() <= len_string)$then(
    len_string + end + 1
  )$otherwise(2000)

  pl$

  when(string$is_null() | start$is_null() | (end$is_null() & !end_is_null))$
    then(pl$lit(NA_character_))$

  when(start > 0 & start > len_string & end > 0 & end > len_string)$
    then(pl$lit(""))$

  when(start_is_zero & end_is_zero)$
    then(pl$lit(""))$

  when(start_is_zero & end_is_null)$
    then(string)$

  when(!start_is_zero & start >= 0 & end < 0 & end$abs() > len_string)$
    then(pl$lit(""))$

  when(start_is_zero & end > 0 & end <= len_string)$
    then(string$str$slice(0, foo2))$

  when(start_is_zero & end > 0 & end > len_string)$
    then(string)$

  when(start_is_zero & end < 0 & end$abs() <= len_string)$
    then(string$str$slice(0, foo6))$

  when(start_is_zero & end < 0 & end$abs() > len_string)$
    then(pl$lit(""))$

  when(start >= 0 & end_is_null)$
    then(string$str$slice(start, foo3))$

  when(start < 0 & end_is_null & start$abs() >= len_string)$
    then(string$str$slice(0, len_string))$

  when(start < 0 & end_is_null & start$abs() < len_string)$
    then(string$str$slice(len_string + start + 1, start$abs()))$

  when(start >= 0 & start <= end & end <= len_string)$
    then(string$str$slice(start, length))$

  when(start < 0 & start$abs() < len_string & end > 0)$
    then(pl$lit(""))$

  when(start < 0 & start$abs() >= len_string & end > 0)$
    then(string$str$slice(0, foo4))$

  when(start < end & end < 0 & start$abs() <= len_string)$
    then(string$str$slice(len_string + start + 1, foo))$

  when(start >= 0 & end < 0 & end$abs() <= len_string)$
    then(string$str$slice(start, foo5))$

  when(start > 0 & end_is_zero)$
    then(pl$lit(""))$

  when(start < 0 & end < 0 & start$abs() > len_string & end$abs() > len_string)$
    then(pl$lit(""))$

  when(start < 0 & end_is_zero & start$abs() > len_string)$
    then(pl$lit(""))$

  when(start > 0 & end > 0 & start > end)$then(pl$lit(""))
}

pl_substr <- function(x, start, stop) {
  x <- x$cast(pl$String)
  len_string <- x$str$len_chars()
  if (!is_polars_expr(start)) {
    start <- pl$lit(start)
  }
  if (!is_polars_expr(stop)) {
    stop <- pl$lit(stop)
  }
  start <- start$cast(pl$Int64)
  stop <- stop$cast(pl$Int64)

  old_start <- start
  start_is_zero <- old_start == 0
  stop_is_zero <- stop == 0
  start <- old_start - 1
  length <- stop - old_start
  length <- pl$when(length < 0)$then(pl$lit(0))$otherwise(length + 1)
  # +1 because when start = stop we still want to take one character

  # I need to have something like this that is used only in a special case
  # below because polars eagerly evaluates all branches and then applies
  # them, so having length = length - 1 errors when length = 0

  # Probably a bunch of useless conditions below since they're copied from
  # pl_str_sub_stringr but I don't have the motivation to clean this since it
  # works
  foo <- pl$when(start < stop & stop < 0 & start$abs() <= len_string)$then(
    length
  )$otherwise(2000)

  foo2 <- pl$when(start_is_zero & stop$abs() <= len_string)$then(
    len_string - stop - 1
  )$otherwise(2000)

  foo3 <- pl$when(start > 0 & start <= len_string & stop > len_string)$then(
    len_string - start
  )$otherwise(2000)

  foo4 <- pl$when(start < 0 & stop > 0)$then(
    stop
  )$otherwise(2000)

  foo5 <- pl$when(start >= 0 & stop < 0 & stop$abs() <= len_string)$then(
    len_string + stop + 1
  )$otherwise(2000)

  foo6 <- pl$when(start_is_zero & stop > 0 & stop$abs() <= len_string)$then(
    stop
  )$otherwise(2000)

  pl$

  when(x$is_null() | start$is_null() | stop$is_null())$
    then(pl$lit(NA_character_))$

  when(start >= 0 & stop > len_string)$
    then(x$str$slice(start, foo3))$

  when(start_is_zero & stop > 0 & stop$abs() <= len_string)$
    then(x$str$slice(0, foo6))$

  when(start_is_zero & stop_is_zero)$
    then(pl$lit(""))$

  when(start_is_zero & stop < 0 & stop$abs() > len_string)$
    then(pl$lit(""))$

  when(start_is_zero & stop$abs() > len_string)$
    then(x$str$slice(0, len_string))$

  when(start < 0 & stop <= 0)$
    then(pl$lit(""))$

  when(start > 0 & stop <= 0)$
    then(pl$lit(""))$

  when(start >= 0 & start <= stop & stop <= len_string)$
    then(x$str$slice(start, length))$

  when(start < 0 & stop > 0)$
    then(x$str$slice(0, foo4))$

  when(start < stop & stop < 0 & start$abs() <= len_string)$
    then(x$str$slice(len_string + start + 1, foo))$

  when(start >= 0 & stop < 0 & stop$abs() <= len_string)$
    then(x$str$slice(start, foo5))$

  when(start > 0 & stop_is_zero)$
    then(pl$lit(""))$

  when(start < 0 & stop < 0 & start$abs() > len_string & stop$abs() > len_string)$
    then(pl$lit(""))$

  when(start > 0 & stop > 0 & start > stop)$then(pl$lit(""))
}

# I would need `$splitn()` for cases where n is not Inf, but it returns a struct
# that I'd like to unnest directly and this is apparently not possible:
# https://github.com/pola-rs/polars/issues/13481
#
# Expresses the same objective as me:
# https://github.com/pola-rs/polars/issues/13649
pl_str_split_stringr <- function(string, pattern, ...) {
  check_empty_dots(...)
  string$str$split(by = pattern, inclusive = FALSE)
}

pl_str_split_i_stringr <- function(string, pattern, i, ...) {
  check_empty_dots(...)
  if (i == 0) {
    cli_abort("{.code i} must not be 0.", call = env_from_dots(...))
  } else if (i >= 1) {
    i <- i - 1
  }
  string$str$split(by = pattern, inclusive = FALSE)$list$get(
    i,
    null_on_oob = TRUE
  )
}

pl_str_replace_na_stringr <- function(string, replacement = "NA", ...) {
  replacement <- polars_expr_to_r(replacement)
  check_string(replacement, allow_na = FALSE)

  string$replace_strict(
    old = NA,
    new = replacement,
    default = string,
    return_dtype = pl$String
  )
}

pl_str_to_lower_stringr <- function(string, ...) {
  check_empty_dots(...)
  string$str$to_lowercase()
}
pl_tolower <- pl_str_to_lower_stringr

pl_str_to_upper_stringr <- function(string, ...) {
  check_empty_dots(...)
  string$str$to_uppercase()
}
pl_toupper <- pl_str_to_upper_stringr

pl_str_to_title_stringr <- function(string, ...) {
  check_empty_dots(...)
  string$str$to_titlecase()
}
pl_toTitleCase <- pl_str_to_title_stringr

pl_str_trim_stringr <- function(string, side = "both", ...) {
  check_empty_dots(...)
  side <- polars_expr_to_r(side)

  switch(
    side,
    "both" = string$str$strip_chars(),
    "left" = string$str$strip_chars_start(),
    "right" = string$str$strip_chars_end()
  )
}

pl_trimws <- function(string, which = "both", ...) {
  check_empty_dots(...)
  pl_str_trim_stringr(string, side = which)
}

pl_str_trunc_stringr <- function(
  string,
  width,
  side = "right",
  ellipsis = "..."
) {
  if (width < nchar(ellipsis)) {
    cli_abort(
      paste0(
        "{.code width} ({width}) is shorter than {.code ellipsis} ({nchar(ellipsis)})."
      )
    )
  }
  switch(
    side,
    "left" = pl$concat_str(
      pl$lit(ellipsis),
      string$str$tail(width - nchar(ellipsis))
    ),
    "right" = pl$concat_str(
      string$str$head(width - nchar(ellipsis)),
      pl$lit(ellipsis)
    ),
    "center" = cli_abort("{.code side = \"center\"} is not supported."),
    cli_abort("{.code side} must be either \"left\" or \"right\".")
  )
}

pl_word_stringr <- function(string, start = 1L, end = start, sep = " ", ...) {
  check_empty_dots(...)
  string$str$split(sep)$list$gather((start:end) - 1L)$list$join(sep)
}
