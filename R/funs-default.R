# All these functions should be internal, the user doesn't need to access them

pl_abs <- function(x, ...) {
  check_empty_dots(...)
  x$abs()
}

pl_all <- function(..., na.rm = FALSE) {
  dots <- clean_dots(...)
  env <- env_from_dots(...)
  x <- check_rowwise(...)
  if (length(dots) == 0) {
    abort(
      "`...` is absent, but must be supplied.",
      call = env
    )
  }
  if (isTRUE(x$is_rowwise)) {
    return(x$expr$list$eval(pl$element()$all())$explode())
  }
  if (length(dots) == 1) {
    dots[[1]]$all(drop_nulls = na.rm)
  } else {
    abort(
      "`all()` only works with one element in `...`",
      call = env
    )
  }
}

pl_any <- function(..., na.rm = FALSE) {
  dots <- clean_dots(...)
  env <- env_from_dots(...)
  x <- check_rowwise(...)
  if (length(dots) == 0) {
    abort(
      "`...` is absent, but must be supplied.",
      call = env
    )
  }
  if (isTRUE(x$is_rowwise)) {
    return(x$expr$list$eval(pl$element()$any())$explode())
  }
  if (length(dots) == 1) {
    dots[[1]]$any(drop_nulls = na.rm)
  } else {
    abort(
      "`any()` only works with one element in `...`",
      call = env
    )
  }
}

pl_mean <- function(x, ...) {
  check_empty_dots(...)
  x <- check_rowwise(x, ...)
  if (isTRUE(x$is_rowwise)) {
    x$expr$list$eval(pl$element()$mean())$explode()
  } else {
    x$expr$mean()
  }
}

pl_median <- function(x, ...) {
  check_empty_dots(...)
  x <- check_rowwise(x, ...)
  if (isTRUE(x$is_rowwise)) {
    x$expr$list$eval(pl$element()$median())$explode()
  } else {
    x$expr$median()
  }
}

pl_min <- function(x, ...) {
  check_empty_dots(...)
  x <- check_rowwise(x, ...)
  if (isTRUE(x$is_rowwise)) {
    x$expr$list$eval(pl$element()$min())$explode()
  } else {
    x$expr$min()
  }
}

pl_max <- function(x, ...) {
  check_empty_dots(...)
  x <- check_rowwise(x, ...)
  if (isTRUE(x$is_rowwise)) {
    x$expr$list$eval(pl$element()$max())$explode()
  } else {
    x$expr$max()
  }
}

pl_sum <- function(..., na.rm = FALSE) {
  if (isTRUE(na.rm)) {
    rlang::inform("Argument `na.rm` in `sum()` is ignored.")
  }
  x <- check_rowwise_dots(...)
  if (isTRUE(x$is_rowwise)) {
    x$expr$list$eval(pl$element()$sum())$explode()
  } else {
    x$expr$sum()
  }
}

pl_sd <- function(x, ddof = 1, ...) {
  check_empty_dots(...)
  x <- check_rowwise(x, ...)
  if (isTRUE(x$is_rowwise)) {
    x$expr$list$eval(pl$element()$std(ddof = ddof))$explode()
  } else {
    x$expr$std(ddof = ddof)
  }
}

pl_floor <- function(x, ...) {
  check_empty_dots(...)
  x$floor()
}

pl_acos <- function(x, ...) {
  check_empty_dots(...)
  x$arccos()
}

pl_acosh <- function(x, ...) {
  check_empty_dots(...)
  x$arccosh()
}

pl_asin <- function(x, ...) {
  check_empty_dots(...)
  x$arcsin()
}

pl_asinh <- function(x, ...) {
  check_empty_dots(...)
  x$arcsinh()
}

pl_atan <- function(x, ...) {
  check_empty_dots(...)
  x$arctan()
}

pl_atanh <- function(x, ...) {
  check_empty_dots(...)
  x$arctanh()
}

pl_between_dplyr <- function(x, left, right, ...) {
  check_empty_dots(...)
  x$is_between(lower_bound = left, upper_bound = right, closed = "both")
}

pl_case_match <- function(x, ..., .data) {
  env <- env_from_dots(...)
  new_vars <- new_vars_from_dots(...)
  dots <- clean_dots(...)

  x <- polars::pl$col(deparse(substitute(x)))

  if (!".default" %in% names(dots)) {
    dots[[length(dots) + 1]] <- c(".default" = NA)
  }

  out <- NULL
  for (y in seq_along(dots)) {
    if (y == length(dots)) {
      otw <- translate_expr(.data, dots[[y]], new_vars = new_vars, env = env)
      out <- out$otherwise(otw)
      next
    }
    lhs <- translate_expr(.data, dots[[y]][[2]], new_vars = new_vars, env = env)
    rhs <- translate_expr(.data, dots[[y]][[3]], new_vars = new_vars, env = env)
    if (is.null(out)) {
      out <- polars::pl$when(x$is_in(lhs))$then(rhs)
    } else {
      out <- out$when(x$is_in(lhs))$then(rhs)
    }
  }

  out
}

pl_case_when <- function(..., .data) {
  env <- env_from_dots(...)
  new_vars <- new_vars_from_dots(...)
  dots <- clean_dots(...)

  if (!".default" %in% names(dots)) {
    dots[[length(dots) + 1]] <- c(".default" = NA)
  }

  out <- NULL
  for (y in seq_along(dots)) {
    if (y == length(dots)) {
      otw <- translate_expr(.data, dots[[y]], new_vars = new_vars, env = env)
      out <- out$otherwise(otw)
      next
    }
    lhs <- translate_expr(.data, dots[[y]][[2]], new_vars = new_vars, env = env)
    rhs <- translate_expr(.data, dots[[y]][[3]], new_vars = new_vars, env = env)

    if (is.null(out)) {
      out <- polars::pl$when(lhs)$then(rhs)
    } else {
      out <- out$when(lhs)$then(rhs)
    }
  }
  out
}

pl_ceiling <- function(x, ...) {
  check_empty_dots(...)
  x$ceil()
}

pl_coalesce_dplyr <- function(..., default = NULL) {
  # pl$coalesce() doesn't accept a list
  call2(pl$coalesce, !!!clean_dots(...), default) |> eval_bare()
}

pl_consecutive_id_dplyr <- function(...) {
  dots <- clean_dots(...)
  env <- env_from_dots(...)
  if (length(dots) == 0) {
    abort(
      "`...` is absent, but must be supplied.",
      call = env
    )
  }
  dots <- pl$struct(dots)
  dots$rle_id() + 1
}

pl_cos <- function(x, ...) {
  check_empty_dots(...)
  x$cos()
}

pl_cosh <- function(x, ...) {
  check_empty_dots(...)
  x$cosh()
}

pl_cumcount <- function(x, ...) {
  check_empty_dots(...)
  x$cum_count()
}

pl_cummin <- function(x, ...) {
  check_empty_dots(...)
  x$cum_min()
}

pl_cumprod <- function(x, ...) {
  check_empty_dots(...)
  x$cum_prod()
}

pl_cumsum <- function(x, ...) {
  check_empty_dots(...)
  x$cum_sum()
}

pl_diff <- function(x, lag = 1, differences = 1, ...) {
  check_empty_dots(...)
  if (!is.null(differences) && length(differences) == 1 && differences != 1) {
    rlang::abort(
      "polars doesn't support `diff()` if argument `differences` is not equal to 1.",
      call = env_from_dots(...)
    )
  }
  x$diff(n = lag, null_behavior = "drop")
}

pl_duplicated <- function(x, ...) {
  check_empty_dots(...)
  x$duplicated()
}

pl_exp <- function(x, ...) {
  check_empty_dots(...)
  x$exp()
}

pl_first_dplyr <- function(x, ...) {
  check_empty_dots(...)
  x$first()
}

pl_ifelse <- function(cond, yes, no, .data, ...) {
  check_empty_dots(...)
  env <- env_from_dots(...)
  new_vars <- new_vars_from_dots(...)

  cond <- translate_expr(.data, enexpr(cond), new_vars = new_vars, env = env)
  yes <- translate_expr(.data, enexpr(yes), new_vars = new_vars, env = env)
  no <- translate_expr(.data, enexpr(no), new_vars = new_vars, env = env)
  pl$when(cond)$then(yes)$otherwise(no)
}

pl_infinite <- function(x, ...) {
  check_empty_dots(...)
  x$infinite()
}

pl_interpolate <- function(x, ...) {
  check_empty_dots(...)
  x$interpolate()
}

pl_is.finite <- function(x, ...) {
  check_empty_dots(...)
  x$is_finite()
}

pl_is_first <- function(x, ...) {
  check_empty_dots(...)
  x$is_first()
}

pl_is.infinite <- function(x, ...) {
  check_empty_dots(...)
  x$is_infinite()
}

pl_is.nan <- function(x, ...) {
  check_empty_dots(...)
  x$is_nan()
}

pl_is.null <- function(x, ...) {
  check_empty_dots(...)
  x$is_null()
}

pl_kurtosis <- function(x, ...) {
  check_empty_dots(...)
  x$kurtosis()
}

pl_lag <- function(x, k = 1, ...) {
  check_empty_dots(...)
  x$shift(k)
}

pl_lag_dplyr <- function(x, n = 1, ...) {
  check_empty_dots(...)
  x$shift(n)
}

pl_last_dplyr <- function(x, ...) {
  check_empty_dots(...)
  x$last()
}

pl_length <- function(x) {
  x$len()
}

pl_log <- function(x, ...) {
  check_empty_dots(...)
  x$log()
}

pl_log10 <- function(x, ...) {
  check_empty_dots(...)
  x$log10()
}

pl_mode <- function(x, ...) {
  check_empty_dots(...)
  x$mode()
}

pl_min_rank_dplyr <- function(x) {
  x$rank(method = "min")
}

pl_n_dplyr <- function(...) {
  check_empty_dots()
  pl$len()
}

pl_na_if_dplyr <- function(x, y) {
  if (length(y) == 1 && !inherits(y, "RPolarsExpr") && is.na(y)) {
    pl$when(x$is_null())$then(pl$lit(NA))$otherwise(x)
  } else {
    pl$when(x == y)$then(pl$lit(NA))$otherwise(x)
  }
}

pl_n_distinct_dplyr <- function(..., na.rm = FALSE) {
  dots <- clean_dots(...)
  if (length(dots) == 0) {
    abort(
      "`...` is absent, but must be supplied.",
      call = env_from_dots(...)
    )
  }
  dots <- pl$struct(dots)
  if (isTRUE(na.rm)) {
    dots$drop_nulls()$n_unique()
  } else {
    dots$n_unique()
  }
}

pl_nth_dplyr <- function(x, n, ...) {
  if (length(n) > 1) {
    abort(
      paste0("`n` must have size 1, not size ", length(n), "."),
      call = env_from_dots(...)
    )
  }
  if (is.na(n)) {
    abort(
      "`n` can't be `NA`.",
      call = env_from_dots(...)
    )
  }
  if (as.integer(n) != n) {
    abort(
      "`n` must be an integer.",
      call = env_from_dots(...)
    )
  }
  # 0-indexed
  if (n > 0) {
    n <- n - 1
  }
  x$gather(n)
}

pl_rank <- function(x, ...) {
  check_empty_dots(...)
  x$rank()
}

pl_replace_na_tidyr <- function(data, replace, ...) {
  check_empty_dots(...)
  data$fill_null(replace)
}

pl_round <- function(x, digits = 0, ...) {
  check_empty_dots(...)
  x$round(decimals = digits)
}

pl_rev <- function(x) {
  x$reverse()
}

pl_sample <- function(x, size = NULL, replace = FALSE, ...) {
  check_empty_dots(...)
  # TODO: how should I handle seed, given that R sample() doesn't have this arg
  x$sample(n = size, with_replacement = replace, shuffle = TRUE)
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

pl_sort <- function(x, ...) {
  check_empty_dots(...)
  x$sort()
}

pl_sqrt <- function(x, ...) {
  check_empty_dots(...)
  x$sqrt()
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

pl_unique_counts <- function(x, ...) {
  check_empty_dots(...)
  x$unique_counts()
}

pl_var <- function(x, ddof = 1, ...) {
  check_empty_dots(...)
  x$var(ddof = ddof)
}

pl_which.max <- function(x, ...) {
  check_empty_dots(...)
  x$arg_max() + 1
}

pl_which.min <- function(x, ...) {
  check_empty_dots(...)
  x$arg_min() + 1
}
