pl_grepl <- function(pattern, x, fixed = FALSE, ...) {
	if (isTRUE(fixed)) {
		attr(x, "stringr_attr") <- "fixed"
	}
	pl_str_detect_stringr(string = x, pattern = pattern, ...)
}

pl_paste0 <- function(..., collapse = NULL) {
	pl_paste(..., sep = "", collapse = collapse)
}

pl_paste <- function(..., sep = " ", collapse = NULL) {
	sep <- polars_expr_to_r(sep)
	dots <- clean_dots(...)
	# paste(NA) -> "NA"
	dots <- lapply(seq_along(dots), function(x) {
		elem <- dots[[x]]
		if (!inherits(elem, "RPolarsExpr")) {
			return(elem)
		}
		elem$fill_null(pl$lit("NA"))
	})
	call2(pl$concat_str, !!!dots, separator = sep) |>
		eval_bare()
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
	if (!inherits(times, "RPolarsExpr")) {
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

# TODO: this requires https://github.com/pola-rs/polars/issues/11455
# pl_str_equal_string <- function(x, y, ...) {
#
# }

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

# group = 0 means the whole match
pl_str_extract_stringr <- function(string, pattern, group = 0, ...) {
	check_empty_dots(...)
	pattern <- check_pattern(pattern)
	# if pattern wasn't passed to pl$col() at this point then it must be parsed
	# as a literal otherwise extract() will error because can't find a column
	# named as pattern
	if (!inherits(pattern$pattern, "RPolarsExpr")) {
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
		abort(
			"`str_pad()` doesn't work in a Polars DataFrame when `use_width = FALSE`",
			class = "tidypolars_error"
		)
	}

	if (length(width) > 1) {
		abort(
			"`str_pad()` doesn't work in a Polars DataFrame when `width` has a length greater than 1.",
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
		"both" = abort(
			'`str_pad()` doesn\'t work in a Polars DataFrame when `side = "both"`',
			class = "tidypolars_error"
		),
		# polars and dplyr have the opposite understanding for "side"
		"left" = string$str$pad_start(width = width, fillchar = pad),
		"right" = string$str$pad_end(width = width, fillchar = pad)
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
	string$str$replace_all(pattern$pattern, "")
}

pl_str_replace_stringr <- function(string, pattern, replacement, ...) {
	check_empty_dots(...)
	pattern <- check_pattern(pattern)
	if (is.character(replacement)) {
		replacement <- parse_replacement(replacement)
	}
	string$str$replace(pattern$pattern, replacement)
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
		out <- string$str$replace_all(pattern$pattern, replacement)
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

pl_str_sub_stringr <- function(string, start, end = NULL, ...) {
	check_empty_dots(...)
	start <- polars_expr_to_r(start)
	end <- polars_expr_to_r(end)

	if (is.na(start) || (!is.null(end) && is.na(end))) {
		return(pl$lit(NA_character_))
	}

	# polars is 0-indexed
	if (start > 0) {
		start <- start - 1
	}
	if (is.null(end)) {
		length <- NULL
	} else if (end >= 0) {
		length <- end - start
	} else if (end == -1) {
		length <- end - start + 1
	} else if (end < -1) {
		end <- end + 1
		# Do not make this the default because I guess it's more expensive
		return(string$str$slice(start)$str$head(end))
	}
	string$str$slice(start, length)
}

pl_substr <- function(x, start, stop) {
	if (is.na(start) | is.na(stop)) {
		return(pl$lit(NA_character_))
	}
	if (start < 0 | stop < 0) {
		return(pl$lit(""))
	}
	# polars is 0-indexed
	if (start > 0) {
		start <- start - 1
	}
	length <- stop - start
	x$str$slice(start, length)
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
		abort("`i` must not be 0.", call = env_from_dots(...))
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
	if (
		length(replacement) > 1 || is.na(replacement) || !is.character(replacement)
	) {
		abort("`replacement` must be a single string.", call = env_from_dots(...))
	}
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
		abort(
			paste0(
				"`width` (",
				width,
				") is shorter than `ellipsis` (",
				nchar(ellipsis),
				")."
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
		"center" = abort("`side = \"center\" is not supported.`"),
		abort("`side` must be either \"left\" or \"right\".")
	)
}

pl_word_stringr <- function(string, start = 1L, end = start, sep = " ", ...) {
	check_empty_dots(...)
	string$str$split(sep)$list$gather((start:end) - 1L)$list$join(sep)
}
