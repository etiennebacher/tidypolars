# All these functions should be internal, the user doesn't need to access them

###### DEFAULT FUNCTIONS

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

pl_std <- function(x, ddof = 1, ...) {
  check_empty_dots(...)
  x$std(ddof = ddof)
}

pl_floor <- function(x, ...) {
  check_empty_dots(...)
  x$floor()
}

pl_add <- function(x, ...) {
  check_empty_dots(...)
  x$add()
}

pl_alias <- function(x, ...) {
  check_empty_dots(...)
  x$alias()
}

pl_all <- function(x, ...) {
  check_empty_dots(...)
  x$all()
}

pl_and <- function(x, ...) {
  check_empty_dots(...)
  x$and()
}

pl_any <- function(x, ...) {
  check_empty_dots(...)
  x$any()
}

pl_append <- function(x, ...) {
  check_empty_dots(...)
  x$append()
}

pl_apply <- function(x, ...) {
  check_empty_dots(...)
  x$apply()
}

pl_approx_unique <- function(x, ...) {
  check_empty_dots(...)
  x$approx_unique()
}

pl_arccos <- function(x) {
  x$arccos()
}

pl_arccosh <- function(x) {
  x$arccosh()
}

pl_arcsin <- function(x) {
  x$arcsin()
}

pl_arcsinh <- function(x) {
  x$arcsinh()
}

pl_arctan <- function(x) {
  x$arctan()
}

pl_arctanh <- function(x) {
  x$arctanh()
}

pl_arg_max <- function(x, ...) {
  check_empty_dots(...)
  x$arg_max()
}

pl_arg_min <- function(x, ...) {
  check_empty_dots(...)
  x$arg_min()
}

pl_arg_sort <- function(x, ...) {
  check_empty_dots(...)
  x$arg_sort()
}

pl_arg_unique <- function(x, ...) {
  check_empty_dots(...)
  x$arg_unique()
}

pl_arr <- function(x, ...) {
  check_empty_dots(...)
  x$arr()
}

pl_backward_fill <- function(x, ...) {
  check_empty_dots(...)
  x$backward_fill()
}

pl_forward_fill <- function(x, ...) {
  check_empty_dots(...)
  x$forward_fill()
}

pl_is_between <- function(x, left, right, include_bounds = TRUE, ...) {
  check_empty_dots(...)
  x$is_between(start = left, end = right, include_bounds = include_bounds)
}

pl_bin <- function(x, ...) {
  check_empty_dots(...)
  x$bin()
}

pl_case_match <- function(x, ...) {
  dots <- get_dots(...)

  if (!".default" %in% names(dots)) {
    dots[[length(dots) + 1]] <- NA
    names(dots)[length(dots)] <- ".default"
  }

  exprs <- lapply(seq_along(dots), \(x) {
    dep <- safe_deparse(dots[[x]])
    if (x == length(dots)) {
      return(paste0("$otherwise(", dep, ")"))
    }

    spl <- strsplit(dep, "~")[[1]] |>
      trimws()

    paste0("$when(x$is_in(pl$lit(", spl[1], ")))$then(", spl[2], ")")
  }) |>
    paste(collapse = "")

  paste0("pl", exprs) |>
    str2lang() |>
    eval()
}



pl_case_when <- function(...) {
  dots <- get_dots(...)

  if (!".default" %in% names(dots)) {
    dots[[length(dots) + 1]] <- NA
    names(dots)[length(dots)] <- ".default"
  }

  exprs <- lapply(seq_along(dots), \(x) {
    dep <- safe_deparse(dots[[x]])

    if (x == length(dots)) {
      return(paste0("$otherwise(", dep, ")"))
    }
    spl <- strsplit(dep, "~")[[1]] |>
      trimws()
    paste0("$when(", spl[1], ")$then(", spl[2], ")")
  }) |>
    paste(collapse = "")

  paste0("pl", exprs) |>
    str2lang() |>
    eval()
}

pl_cast <- function(x, ...) {
  check_empty_dots(...)
  x$cast()
}

pl_cat <- function(x, ...) {
  check_empty_dots(...)
  x$cat()
}

pl_ceil <- function(x, ...) {
  check_empty_dots(...)
  x$ceil()
}

pl_class <- function(x, ...) {
  check_empty_dots(...)
  x$class()
}

pl_clip <- function(x, ...) {
  check_empty_dots(...)
  x$clip()
}

pl_coalesce <- function(..., default = NULL) {
  dots <- get_dots(...)
  pl$coalesce(..., default)
}

pl_extend_constant <- function(x, ...) {
  check_empty_dots(...)
  x$extend_constant()
}

pl_cos <- function(x) {
  x$cos()
}

pl_cosh <- function(x) {
  x$cosh()
}

pl_counts <- function(x, ...) {
  check_empty_dots(...)
  x$counts()
}

pl_cumcount <- function(x, ...) {
  check_empty_dots(...)
  x$cumcount()
}

pl_cummin <- function(x, ...) {
  check_empty_dots(...)
  x$cummin()
}

pl_cumprod <- function(x, ...) {
  check_empty_dots(...)
  x$cumprod()
}

pl_cumsum <- function(x, ...) {
  check_empty_dots(...)
  x$cumsum()
}

pl_cumulative_eval <- function(x, ...) {
  check_empty_dots(...)
  x$cumulative_eval()
}

pl_df <- function(x, ...) {
  check_empty_dots(...)
  x$df()
}

pl_diff <- function(x, ...) {
  check_empty_dots(...)
  x$diff()
}

pl_div <- function(x, ...) {
  check_empty_dots(...)
  x$div()
}

pl_dot <- function(x, ...) {
  check_empty_dots(...)
  x$dot()
}

pl_dt <- function(x, ...) {
  check_empty_dots(...)
  x$dt()
}

pl_duplicated <- function(x, ...) {
  check_empty_dots(...)
  x$duplicated()
}

pl_entropy <- function(x, ...) {
  check_empty_dots(...)
  x$entropy()
}

pl_eq <- function(x, ...) {
  check_empty_dots(...)
  x$eq()
}

pl_gt_eq <- function(x, ...) {
  check_empty_dots(...)
  x$gt_eq()
}

pl_eval <- function(x, ...) {
  check_empty_dots(...)
  x$eval()
}

pl_exclude <- function(x, ...) {
  check_empty_dots(...)
  x$exclude()
}

pl_exp <- function(x, ...) {
  check_empty_dots(...)
  x$exp()
}

pl_explode <- function(x, ...) {
  check_empty_dots(...)
  x$explode()
}

pl_extend <- function(x, ...) {
  check_empty_dots(...)
  x$extend()
}

pl_first <- function(x, ...) {
  check_empty_dots(...)
  x$first()
}

pl_agg_groups <- function(x, ...) {
  check_empty_dots(...)
  x$agg_groups()
}

pl_gt <- function(x, ...) {
  check_empty_dots(...)
  x$gt()
}

pl_hash <- function(x, ...) {
  check_empty_dots(...)
  x$hash()
}

pl_head <- function(x, ...) {
  check_empty_dots(...)
  x$head()
}

pl_ifelse <- function(cond, yes, no) {
  pl$when(cond)$then(yes)$otherwise(no)
}

pl_if_else <- pl_ifelse

pl_in <- function(x, ...) {
  check_empty_dots(...)
  # x$in()
}

pl_infinite <- function(x, ...) {
  check_empty_dots(...)
  x$infinite()
}

pl_inspect <- function(x, ...) {
  check_empty_dots(...)
  x$inspect()
}

pl_interpolate <- function(x, ...) {
  check_empty_dots(...)
  x$interpolate()
}

pl_is_duplicated <- function(x, ...) {
  check_empty_dots(...)
  x$is_duplicated()
}

pl_is_finite <- function(x, ...) {
  check_empty_dots(...)
  x$is_finite()
}

pl_is_first <- function(x, ...) {
  check_empty_dots(...)
  x$is_first()
}

pl_is_infinite <- function(x, ...) {
  check_empty_dots(...)
  x$is_infinite()
}

pl_is_nan <- function(x, ...) {
  check_empty_dots(...)
  x$is_nan()
}

pl_is_not <- function(x, ...) {
  check_empty_dots(...)
  x$is_not()
}

pl_is_not_nan <- function(x, ...) {
  check_empty_dots(...)
  x$is_not_nan()
}

pl_is_not_null <- function(x, ...) {
  check_empty_dots(...)
  x$is_not_null()
}

pl_is_null <- function(x, ...) {
  check_empty_dots(...)
  x$is_null()
}

pl_is_unique <- function(x, ...) {
  check_empty_dots(...)
  x$is_unique()
}

pl_bottom_k <- function(x, ...) {
  check_empty_dots(...)
  x$bottom_k()
}

pl_kurtosis <- function(x, ...) {
  check_empty_dots(...)
  x$kurtosis()
}

pl_last <- function(x, ...) {
  check_empty_dots(...)
  x$last()
}

pl_limit <- function(x, ...) {
  check_empty_dots(...)
  x$limit()
}

pl_list <- function(x, ...) {
  check_empty_dots(...)
  x$list()
}

pl_log <- function(x, ...) {
  check_empty_dots(...)
  x$log()
}

pl_log10 <- function(x, ...) {
  check_empty_dots(...)
  x$log10()
}

pl_lt <- function(x, ...) {
  check_empty_dots(...)
  x$lt()
}

pl_map <- function(x, ...) {
  check_empty_dots(...)
  x$map()
}

pl_meta <- function(x, ...) {
  check_empty_dots(...)
  x$meta()
}

pl_mode <- function(x, ...) {
  check_empty_dots(...)
  x$mode()
}

pl_mul <- function(x, ...) {
  check_empty_dots(...)
  x$mul()
}

pl_keep_name <- function(x, ...) {
  check_empty_dots(...)
  x$keep_name()
}

pl_name <- function(x, ...) {
  check_empty_dots(...)
  x$name()
}

pl_fill_nan <- function(x, ...) {
  check_empty_dots(...)
  x$fill_nan()
}

pl_drop_nans <- function(x, ...) {
  check_empty_dots(...)
  x$drop_nans()
}

pl_neq <- function(x, ...) {
  check_empty_dots(...)
  x$neq()
}

pl_not <- function(x, ...) {
  check_empty_dots(...)
  x$not()
}

pl_fill_null <- function(x, ...) {
  check_empty_dots(...)
  x$fill_null()
}

pl_drop_nulls <- function(x, ...) {
  check_empty_dots(...)
  x$drop_nulls()
}

pl_or <- function(x, ...) {
  check_empty_dots(...)
  x$or()
}

pl_over <- function(x, ...) {
  check_empty_dots(...)
  x$over()
}

pl_to_physical <- function(x, ...) {
  check_empty_dots(...)
  x$to_physical()
}

pl_pow <- function(x, ...) {
  check_empty_dots(...)
  x$pow()
}

pl_print <- function(x, ...) {
  check_empty_dots(...)
  x$print()
}

pl_product <- function(x, ...) {
  check_empty_dots(...)
  x$product()
}

pl_quantile <- function(x, ...) {
  check_empty_dots(...)
  x$quantile()
}
pl_rank <- function(x, ...) {
  check_empty_dots(...)
  x$rank()
}

pl_rechunk <- function(x, ...) {
  check_empty_dots(...)
  x$rechunk()
}

pl_reinterpret <- function(x, ...) {
  check_empty_dots(...)
  x$reinterpret()
}

pl_rep <- function(x, ...) {
  check_empty_dots(...)
  x$rep()
}

pl_reshape <- function(x, ...) {
  check_empty_dots(...)
  x$reshape()
}

pl_round <- function(x, digits = 0, ...) {
  check_empty_dots(...)
  x$round(decimals = digits)
}

pl_rpow <- function(x, ...) {
  check_empty_dots(...)
  x$rpow()
}

pl_sample <- function(x, ...) {
  check_empty_dots(...)
  x$sample()
}

pl_shift <- function(x, n = 1, k = NULL, ...) {
  check_empty_dots(...)
  if (!is.null(k)) n <- k
  x$shift(n)
}

pl_shuffle <- function(x, ...) {
  check_empty_dots(...)
  x$shuffle()
}

pl_sign <- function(x, ...) {
  check_empty_dots(...)
  x$sign()
}

pl_sin <- function(x, ...) {
  check_empty_dots(...)
  x$sin()
}

pl_sinh <- function(x, ...) {
  check_empty_dots(...)
  x$sinh()
}

pl_skew <- function(x, ...) {
  check_empty_dots(...)
  x$skew()
}

pl_slice <- function(x, ...) {
  check_empty_dots(...)
  x$slice()
}

pl_sort <- function(x, ...) {
  check_empty_dots(...)
  x$sort()
}

pl_sqrt <- function(x, ...) {
  check_empty_dots(...)
  x$sqrt()
}

pl_str <- function(x, ...) {
  check_empty_dots(...)
  x$str()
}

pl_struct <- function(x, ...) {
  check_empty_dots(...)
  x$struct()
}

pl_sub <- function(x, ...) {
  check_empty_dots(...)
  x$sub()
}

pl_sum <- function(x, ...) {
  check_empty_dots(...)
  x$sum()
}

pl_tail <- function(x, ...) {
  check_empty_dots(...)
  x$tail()
}

pl_take <- function(x, ...) {
  check_empty_dots(...)
  x$take()
}

pl_tan <- function(x) {
  x$tan()
}

pl_tanh <- function(x) {
  x$tanh()
}

pl_unique <- function(x, ...) {
  check_empty_dots(...)
  x$unique()
}

pl_unique_counts <- function(x, ...) {
  check_empty_dots(...)
  x$unique_counts()
}

pl_var <- function(x, ddof = 1, ...) {
  check_empty_dots(...)
  x$var(ddof = ddof)
}

pl_ewm_mean <- function(x, ddof = 1, ...) {
  check_empty_dots(...)
  x$ewm_mean(ddof = ddof)
}

pl_ewm_std <- function(x, ddof = 1, ...) {
  check_empty_dots(...)
  x$ewm_std(ddof = ddof)
}

pl_ewm_var <- function(x, ddof = 1, ...) {
  check_empty_dots(...)
  x$ewm_var(ddof = ddof)
}

pl_xor <- function(x, ...) {
  check_empty_dots(...)
  x$xor()
}

pl_lit_to_df <- function(x, ...) {
  check_empty_dots(...)
  x$lit_to_df()
}

pl_lit_to_s <- function(x, ...) {
  check_empty_dots(...)
  x$lit_to_s()
}

pl_lt_eq <- function(x, ...) {
  check_empty_dots(...)
  x$lt_eq()
}

pl_map_alias <- function(x, ...) {
  check_empty_dots(...)
  x$map_alias()
}

pl_n_unique <- function(x, ...) {
  check_empty_dots(...)
  x$n_unique()
}

pl_nan_max <- function(x, ...) {
  check_empty_dots(...)
  x$nan_max()
}

pl_nan_min <- function(x, ...) {
  check_empty_dots(...)
  x$nan_min()
}

pl_null_count <- function(x, ...) {
  check_empty_dots(...)
  x$null_count()
}

pl_pct_change <- function(x, ...) {
  check_empty_dots(...)
  x$pct_change()
}

pl_rep_extend <- function(x, ...) {
  check_empty_dots(...)
  x$rep_extend()
}

pl_repeat_by <- function(x, ...) {
  check_empty_dots(...)
  x$repeat_by()
}

pl_rolling_max <- function(x, ...) {
  check_empty_dots(...)
  x$rolling_max()
}

pl_rolling_mean <- function(x, ...) {
  check_empty_dots(...)
  x$rolling_mean()
}

pl_rolling_median <- function(x, ...) {
  check_empty_dots(...)
  x$rolling_median()
}

pl_rolling_min <- function(x, ...) {
  check_empty_dots(...)
  x$rolling_min()
}

pl_rolling_quantile <- function(x, ...) {
  check_empty_dots(...)
  x$rolling_quantile()
}

pl_rolling_skew <- function(x, ...) {
  check_empty_dots(...)
  x$rolling_skew()
}

pl_rolling_std <- function(x, ...) {
  check_empty_dots(...)
  x$rolling_std()
}

pl_rolling_sum <- function(x, ...) {
  check_empty_dots(...)
  x$rolling_sum()
}

pl_rolling_var <- function(x, ...) {
  check_empty_dots(...)
  x$rolling_var()
}

pl_search_sorted <- function(x, ...) {
  check_empty_dots(...)
  x$search_sorted()
}

pl_set_sorted <- function(x, ...) {
  check_empty_dots(...)
  x$set_sorted()
}

pl_shift_and_fill <- function(x, ...) {
  check_empty_dots(...)
  x$shift_and_fill()
}

pl_shrink_dtype <- function(x, ...) {
  check_empty_dots(...)
  x$shrink_dtype()
}

pl_sort_by <- function(x, ...) {
  check_empty_dots(...)
  x$sort_by()
}

pl_take_every <- function(x, ...) {
  check_empty_dots(...)
  x$take_every()
}

pl_to_physical <- function(x, ...) {
  check_empty_dots(...)
  x$to_physical()
}

pl_to_r <- function(x, ...) {
  check_empty_dots(...)
  x$to_r()
}

pl_to_struct <- function(x, ...) {
  check_empty_dots(...)
  x$to_struct()
}

pl_top_k <- function(x, ...) {
  check_empty_dots(...)
  x$top_k()
}

pl_unique_counts <- function(x, ...) {
  check_empty_dots(...)
  x$unique_counts()
}

pl_upper_lower_bound <- function(x, ...) {
  check_empty_dots(...)
  x$upper_lower_bound()
}

pl_value_counts <- function(x, ...) {
  check_empty_dots(...)
  x$value_counts()
}

pl_when_then_otherwise <- function(x, ...) {
  check_empty_dots(...)
  x$when_then_otherwise()
}



###### DATE-TIME FUNCTIONS

pl_default_round <- function(x, ...) {
  check_empty_dots(...)
  x$default$round()
}

pl_dt_round <- function(x, ...) {
  check_empty_dots(...)
  x$dt$round()
}

pl_dt_cast_time_unit <- function(x, ...) {
  check_empty_dots(...)
  x$dt$cast_time_unit()
}

pl_dt_combine <- function(x, ...) {
  check_empty_dots(...)
  x$dt$combine()
}

pl_dt_convert_time_zone <- function(x, ...) {
  check_empty_dots(...)
  x$dt$convert_time_zone()
}

pl_dt_day <- function(x, ...) {
  check_empty_dots(...)
  x$dt$day()
}

pl_dt_days <- function(x, ...) {
  check_empty_dots(...)
  x$dt$days()
}

pl_dt_epoch <- function(x, ...) {
  check_empty_dots(...)
  x$dt$epoch()
}

pl_dt_hour <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hour()
}

pl_dt_hours <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hours()
}

pl_dt_iso_year <- function(x, ...) {
  check_empty_dots(...)
  x$dt$iso_year()
}

pl_dt_microsecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microsecond()
}

pl_dt_microseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microseconds()
}

pl_dt_millisecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$millisecond()
}

pl_dt_milliseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$milliseconds()
}

pl_dt_minute <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minute()
}

pl_dt_minutes <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minutes()
}

pl_dt_month <- function(x, ...) {
  check_empty_dots(...)
  x$dt$month()
}

pl_dt_nanosecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanosecond()
}

pl_dt_nanoseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanoseconds()
}

pl_dt_offset_by <- function(x, ...) {
  check_empty_dots(...)
  x$dt$offset_by()
}

pl_dt_ordinal_day <- function(x, ...) {
  check_empty_dots(...)
  x$dt$ordinal_day()
}

pl_dt_quarter <- function(x, ...) {
  check_empty_dots(...)
  x$dt$quarter()
}

pl_dt_replace_time_zone <- function(x, ...) {
  check_empty_dots(...)
  x$dt$replace_time_zone()
}

pl_default_round <- function(x, ...) {
  check_empty_dots(...)
  x$default$round()
}

pl_dt_round <- function(x, ...) {
  check_empty_dots(...)
  x$dt$round()
}

pl_dt_second <- function(x, ...) {
  check_empty_dots(...)
  x$dt$second()
}

pl_dt_seconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$seconds()
}

pl_dt_strftime <- function(x, ...) {
  check_empty_dots(...)
  x$dt$strftime()
}

pl_dt_timestamp <- function(x, ...) {
  check_empty_dots(...)
  x$dt$timestamp()
}

pl_dt_truncate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$truncate()
}

pl_dt_tz_localize <- function(x, ...) {
  check_empty_dots(...)
  x$dt$tz_localize()
}

pl_dt_week <- function(x, ...) {
  check_empty_dots(...)
  x$dt$week()
}

# TODO: check the day of weekstart (lubridate starts the
# week on sunday, polars on monday)
pl_dt_weekday <- function(x, ...) {
  check_empty_dots(...)
  x$dt$weekday()
}

pl_dt_with_time_unit <- function(x, ...) {
  check_empty_dots(...)
  x$dt$with_time_unit()
}

pl_dt_year <- function(x, ...) {
  check_empty_dots(...)
  x$dt$year()
}

pl_ymd_hms <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime(pl$Datetime("ms"), "%Y-%m-%d %H:%M:%S", strict = FALSE)
}

pl_ymd_hm <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime(pl$Datetime("ms"), "%Y-%m-%d %H:%M", strict = FALSE)
}


###### STRING FUNCTIONS

pl_str_concat <- function(x, ...) {
  check_empty_dots(...)
  x$str$concat()
}

pl_str_contains <- function(x, ...) {
  check_empty_dots(...)
  x$str$contains()
}

pl_str_count_match <- function(x, ...) {
  check_empty_dots(...)
  x$str$count_match()
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


