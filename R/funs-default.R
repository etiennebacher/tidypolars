# All these functions should be internal, the user doesn't need to access them

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

pl_is_between <- function(x, left, right, include_bounds = TRUE, ...) {
  check_empty_dots(...)
  x$is_between(start = left, end = right, include_bounds = include_bounds)
}

pl_case_match <- function(x, ..., .data) {
  dots <- get_dots(...)

  x <- polars::pl$col(deparse(substitute(x)))

  if (!".default" %in% names(dots)) {
    dots[[length(dots) + 1]] <- c(".default" = NA)
  }

  out <- NULL
  for (y in seq_along(dots)) {
    if (y == length(dots)) {
      out <- out$otherwise(dots[[y]])
      next
    }
    lhs <- translate_expr(.data, dots[[y]][[2]])
    rhs <- translate_expr(.data, dots[[y]][[3]])
    if (is.null(out)) {
      out <- polars::pl$when(x$is_in(lhs))$then(rhs)
    } else {
      out <- out$when(x$is_in(lhs))$then(rhs)
    }
  }
  out
}



pl_case_when <- function(..., .data) {
  dots <- get_dots(...)

  if (!".default" %in% names(dots)) {
    dots[[length(dots) + 1]] <- c(".default" = NA)
  }

  out <- NULL
  for (y in seq_along(dots)) {
    if (y == length(dots)) {
      out <- out$otherwise(dots[[y]])
      next
    }
    lhs <- translate_expr(.data, dots[[y]][[2]])
    rhs <- translate_expr(.data, dots[[y]][[3]])
    if (is.null(out)) {
      out <- polars::pl$when(lhs)$then(rhs)
    } else {
      out <- out$when(lhs)$then(rhs)
    }
  }
  out
}

pl_cast <- function(x, ...) {
  check_empty_dots(...)
  x$cast()
}

pl_ceil <- function(x, ...) {
  check_empty_dots(...)
  x$ceil()
}

pl_clip <- function(x, ...) {
  check_empty_dots(...)
  x$clip()
}

pl_coalesce <- function(..., default = NULL) {
  dots <- get_dots(...)
  pl$coalesce(..., default)
}

pl_cos <- function(x) {
  x$cos()
}

pl_cosh <- function(x) {
  x$cosh()
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

pl_diff <- function(x, ...) {
  check_empty_dots(...)
  x$diff()
}

pl_duplicated <- function(x, ...) {
  check_empty_dots(...)
  x$duplicated()
}

pl_entropy <- function(x, ...) {
  check_empty_dots(...)
  x$entropy()
}

pl_eval <- function(x, ...) {
  check_empty_dots(...)
  x$eval()
}

pl_exp <- function(x, ...) {
  check_empty_dots(...)
  x$exp()
}

pl_explode <- function(x, ...) {
  check_empty_dots(...)
  x$explode()
}

pl_first <- function(x, ...) {
  check_empty_dots(...)
  x$first()
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

pl_infinite <- function(x, ...) {
  check_empty_dots(...)
  x$infinite()
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

pl_map <- function(x, ...) {
  check_empty_dots(...)
  x$map()
}

pl_mode <- function(x, ...) {
  check_empty_dots(...)
  x$mode()
}

pl_mul <- function(x, ...) {
  check_empty_dots(...)
  x$mul()
}

pl_fill_nan <- function(x, ...) {
  check_empty_dots(...)
  x$fill_nan()
}

pl_drop_nans <- function(x, ...) {
  check_empty_dots(...)
  x$drop_nans()
}

pl_fill_null <- function(x, ...) {
  check_empty_dots(...)
  x$fill_null()
}

pl_drop_nulls <- function(x, ...) {
  check_empty_dots(...)
  x$drop_nulls()
}

pl_pow <- function(x, ...) {
  check_empty_dots(...)
  x$pow()
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
