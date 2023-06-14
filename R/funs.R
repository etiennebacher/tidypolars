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

pl_sd <- function(x, ddof = 1, ...) {
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

pl_arccos <- function(x, ...) {
  check_empty_dots(...)
  x$arccos()
}

pl_arccosh <- function(x, ...) {
  check_empty_dots(...)
  x$arccosh()
}

pl_arcsin <- function(x, ...) {
  check_empty_dots(...)
  x$arcsin()
}

pl_arcsinh <- function(x, ...) {
  check_empty_dots(...)
  x$arcsinh()
}

pl_arctan <- function(x, ...) {
  check_empty_dots(...)
  x$arctan()
}

pl_arctanh <- function(x, ...) {
  check_empty_dots(...)
  x$arctanh()
}

pl_arr <- function(x, ...) {
  check_empty_dots(...)
  x$arr()
}

pl_between <- function(x, ...) {
  check_empty_dots(...)
  x$between()
}

pl_bin <- function(x, ...) {
  check_empty_dots(...)
  x$bin()
}

pl_bound <- function(x, ...) {
  check_empty_dots(...)
  x$bound()
}

pl_by <- function(x, ...) {
  check_empty_dots(...)
  x$by()
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

pl_change <- function(x, ...) {
  check_empty_dots(...)
  x$change()
}

pl_class <- function(x, ...) {
  check_empty_dots(...)
  x$class()
}

pl_clip <- function(x, ...) {
  check_empty_dots(...)
  x$clip()
}

pl_constant <- function(x, ...) {
  check_empty_dots(...)
  x$constant()
}

pl_cos <- function(x, ...) {
  check_empty_dots(...)
  x$cos()
}

pl_cosh <- function(x, ...) {
  check_empty_dots(...)
  x$cosh()
}

pl_count <- function(x, ...) {
  check_empty_dots(...)
  x$count()
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

pl_dtype <- function(x, ...) {
  check_empty_dots(...)
  x$dtype()
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

pl_eval <- function(x, ...) {
  check_empty_dots(...)
  x$eval()
}

pl_every <- function(x, ...) {
  check_empty_dots(...)
  x$every()
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

pl_fill <- function(x, ...) {
  check_empty_dots(...)
  x$fill()
}

pl_filter <- function(x, ...) {
  check_empty_dots(...)
  x$filter()
}

pl_finite <- function(x, ...) {
  check_empty_dots(...)
  x$finite()
}

pl_first <- function(x, ...) {
  check_empty_dots(...)
  x$first()
}

pl_groups <- function(x, ...) {
  check_empty_dots(...)
  x$groups()
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

pl_k <- function(x, ...) {
  check_empty_dots(...)
  x$k()
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

pl_name <- function(x, ...) {
  check_empty_dots(...)
  x$name()
}

pl_nan <- function(x, ...) {
  check_empty_dots(...)
  x$nan()
}

pl_nans <- function(x, ...) {
  check_empty_dots(...)
  x$nans()
}

pl_neq <- function(x, ...) {
  check_empty_dots(...)
  x$neq()
}

pl_not <- function(x, ...) {
  check_empty_dots(...)
  x$not()
}

pl_null <- function(x, ...) {
  check_empty_dots(...)
  x$null()
}

pl_nulls <- function(x, ...) {
  check_empty_dots(...)
  x$nulls()
}

pl_or <- function(x, ...) {
  check_empty_dots(...)
  x$or()
}

pl_otherwise <- function(x, ...) {
  check_empty_dots(...)
  x$otherwise()
}

pl_over <- function(x, ...) {
  check_empty_dots(...)
  x$over()
}

pl_physical <- function(x, ...) {
  check_empty_dots(...)
  x$physical()
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

pl_r <- function(x, ...) {
  check_empty_dots(...)
  x$r()
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

pl_round <- function(x, ...) {
  check_empty_dots(...)
  x$round()
}

pl_rpow <- function(x, ...) {
  check_empty_dots(...)
  x$rpow()
}

pl_s <- function(x, ...) {
  check_empty_dots(...)
  x$s()
}

pl_sample <- function(x, ...) {
  check_empty_dots(...)
  x$sample()
}

pl_shift <- function(x, ...) {
  check_empty_dots(...)
  x$shift()
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

pl_sorted <- function(x, ...) {
  check_empty_dots(...)
  x$sorted()
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

pl_tan <- function(x, ...) {
  check_empty_dots(...)
  x$tan()
}

pl_tanh <- function(x, ...) {
  check_empty_dots(...)
  x$tanh()
}

pl_unique <- function(x, ...) {
  check_empty_dots(...)
  x$unique()
}

pl_var <- function(x, ...) {
  check_empty_dots(...)
  x$var()
}

pl_xor <- function(x, ...) {
  check_empty_dots(...)
  x$xor()
}


###### STRING FUNCTIONS


pl_all <- function(x, ...) {
  check_empty_dots(...)
  x$str$all()
}

pl_chars <- function(x, ...) {
  check_empty_dots(...)
  x$str$chars()
}

pl_concat <- function(x, ...) {
  check_empty_dots(...)
  x$str$concat()
}

pl_contains <- function(x, ...) {
  check_empty_dots(...)
  x$str$contains()
}

pl_decode <- function(x, ...) {
  check_empty_dots(...)
  x$str$decode()
}

pl_encode <- function(x, ...) {
  check_empty_dots(...)
  x$str$encode()
}

pl_exact <- function(x, ...) {
  check_empty_dots(...)
  x$str$exact()
}

pl_explode <- function(x, ...) {
  check_empty_dots(...)
  x$str$explode()
}

pl_extract <- function(x, ...) {
  check_empty_dots(...)
  x$str$extract()
}

pl_int <- function(x, ...) {
  check_empty_dots(...)
  x$str$int()
}

pl_lengths <- function(x, ...) {
  check_empty_dots(...)
  x$str$lengths()
}

pl_ljust <- function(x, ...) {
  check_empty_dots(...)
  x$str$ljust()
}

pl_lowercase <- function(x, ...) {
  check_empty_dots(...)
  x$str$lowercase()
}

pl_lstrip <- function(x, ...) {
  check_empty_dots(...)
  x$str$lstrip()
}

pl_match <- function(x, ...) {
  check_empty_dots(...)
  x$str$match()
}

pl_replace <- function(x, ...) {
  check_empty_dots(...)
  x$str$replace()
}

pl_rjust <- function(x, ...) {
  check_empty_dots(...)
  x$str$rjust()
}

pl_rstrip <- function(x, ...) {
  check_empty_dots(...)
  x$str$rstrip()
}

pl_slice <- function(x, ...) {
  check_empty_dots(...)
  x$str$slice()
}

pl_split <- function(x, ...) {
  check_empty_dots(...)
  x$str$split()
}

pl_splitn <- function(x, ...) {
  check_empty_dots(...)
  x$str$splitn()
}

pl_strip <- function(x, ...) {
  check_empty_dots(...)
  x$str$strip()
}

pl_strptime <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime()
}

pl_uppercase <- function(x, ...) {
  check_empty_dots(...)
  x$str$uppercase()
}

pl_with <- function(x, ...) {
  check_empty_dots(...)
  x$str$with()
}

pl_zfill <- function(x, ...) {
  check_empty_dots(...)
  x$str$zfill()
}


###### DATE-TIME FUNCTIONS

pl_by <- function(x, ...) {
  check_empty_dots(...)
  x$dt$by()
}

pl_combine <- function(x, ...) {
  check_empty_dots(...)
  x$dt$combine()
}

pl_day <- function(x, ...) {
  check_empty_dots(...)
  x$dt$day()
}

pl_days <- function(x, ...) {
  check_empty_dots(...)
  x$dt$days()
}

pl_epoch <- function(x, ...) {
  check_empty_dots(...)
  x$dt$epoch()
}

pl_hour <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hour()
}

pl_hours <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hours()
}

pl_localize <- function(x, ...) {
  check_empty_dots(...)
  x$dt$localize()
}

pl_microsecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microsecond()
}

pl_microseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microseconds()
}

pl_millisecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$millisecond()
}

pl_milliseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$milliseconds()
}

pl_minute <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minute()
}

pl_minutes <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minutes()
}

pl_month <- function(x, ...) {
  check_empty_dots(...)
  x$dt$month()
}

pl_nanosecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanosecond()
}

pl_nanoseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanoseconds()
}

pl_quarter <- function(x, ...) {
  check_empty_dots(...)
  x$dt$quarter()
}

pl_round <- function(x, ...) {
  check_empty_dots(...)
  x$dt$round()
}

pl_second <- function(x, ...) {
  check_empty_dots(...)
  x$dt$second()
}

pl_seconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$seconds()
}

pl_strftime <- function(x, ...) {
  check_empty_dots(...)
  x$dt$strftime()
}

pl_timestamp <- function(x, ...) {
  check_empty_dots(...)
  x$dt$timestamp()
}

pl_truncate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$truncate()
}

pl_unit <- function(x, ...) {
  check_empty_dots(...)
  x$dt$unit()
}

pl_week <- function(x, ...) {
  check_empty_dots(...)
  x$dt$week()
}

pl_weekday <- function(x, ...) {
  check_empty_dots(...)
  x$dt$weekday()
}

pl_year <- function(x, ...) {
  check_empty_dots(...)
  x$dt$year()
}

pl_zone <- function(x, ...) {
  check_empty_dots(...)
  x$dt$zone()
}
