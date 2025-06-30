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
    cli_abort(
      "{.code ...} is absent, but must be supplied.",
      call = env
    )
  }
  if (isTRUE(x$is_rowwise)) {
    return(x$expr$list$eval(pl$element()$all())$explode())
  }
  if (length(dots) == 1) {
    dots[[1]]$all(ignore_nulls = na.rm)
  } else {
    cli_abort(
      "{.code all()} only works with one element in {.code ...}",
      call = env
    )
  }
}

pl_any <- function(..., na.rm = FALSE) {
  dots <- clean_dots(...)
  env <- env_from_dots(...)
  x <- check_rowwise(...)
  if (length(dots) == 0) {
    cli_abort(
      "{.code ...} is absent, but must be supplied.",
      call = env
    )
  }
  if (isTRUE(x$is_rowwise)) {
    return(x$expr$list$eval(pl$element()$any())$explode())
  }
  if (length(dots) == 1) {
    dots[[1]]$any(ignore_nulls = na.rm)
  } else {
    cli_abort(
      "`any()` only works with one element in {.code ...}",
      call = env
    )
  }
}

pl_desc_dplyr <- function(x) {
  attr(x, "descending") <- TRUE
  x
}

pl_mean <- function(x, na.rm = FALSE, ...) {
  check_empty_dots(...)
  x <- check_rowwise(x, ...)
  if (isTRUE(x$is_rowwise)) {
    if (isTRUE(na.rm)) {
      x$expr$list$eval(pl$element()$mean())$explode()
    } else {
      x$expr$list$eval(
        pl$when(pl$element()$has_nulls())$then(NA)$otherwise(
          pl$element()$mean()
        )
      )$explode()
    }
  } else {
    if (isTRUE(na.rm)) {
      x$expr$mean()
    } else {
      pl$when(x$expr$has_nulls())$then(NA)$otherwise(x$expr$mean())
    }
  }
}

pl_median <- function(x, na.rm = FALSE, ...) {
  check_empty_dots(...)
  x <- check_rowwise(x, ...)
  if (isTRUE(x$is_rowwise)) {
    if (isTRUE(na.rm)) {
      x$expr$list$eval(pl$element()$median())$explode()
    } else {
      x$expr$list$eval(
        pl$when(pl$element()$has_nulls())$then(NA)$otherwise(
          pl$element()$median()
        )
      )$explode()
    }
  } else {
    if (isTRUE(na.rm)) {
      x$expr$median()
    } else {
      pl$when(x$expr$has_nulls())$then(NA)$otherwise(x$expr$median())
    }
  }
}

pl_min <- function(x, na.rm = FALSE, ...) {
  check_empty_dots(...)
  x <- check_rowwise(x, ...)
  if (isTRUE(x$is_rowwise)) {
    if (isTRUE(na.rm)) {
      x$expr$list$eval(pl$element()$min())$explode()
    } else {
      x$expr$list$eval(
        pl$when(pl$element()$has_nulls())$then(NA)$otherwise(pl$element()$min())
      )$explode()
    }
  } else {
    if (isTRUE(na.rm)) {
      x$expr$min()
    } else {
      pl$when(x$expr$has_nulls())$then(NA)$otherwise(x$expr$min())
    }
  }
}

pl_max <- function(x, na.rm = FALSE, ...) {
  check_empty_dots(...)
  x <- check_rowwise(x, ...)
  if (isTRUE(x$is_rowwise)) {
    if (isTRUE(na.rm)) {
      x$expr$list$eval(pl$element()$max())$explode()
    } else {
      x$expr$list$eval(
        pl$when(pl$element()$has_nulls())$then(NA)$otherwise(pl$element()$max())
      )$explode()
    }
  } else {
    if (isTRUE(na.rm)) {
      x$expr$max()
    } else {
      pl$when(x$expr$has_nulls())$then(NA)$otherwise(x$expr$max())
    }
  }
}

pl_sum <- function(..., na.rm = FALSE) {
  x <- check_rowwise_dots(...)
  if (isTRUE(x$is_rowwise)) {
    if (isTRUE(na.rm)) {
      x$expr$list$eval(pl$element()$sum())$explode()
    } else {
      x$expr$list$eval(
        pl$when(pl$element()$has_nulls())$then(NA)$otherwise(pl$element()$sum())
      )$explode()
    }
  } else {
    if (isTRUE(na.rm)) {
      x$expr$sum()
    } else {
      pl$when(x$expr$has_nulls())$then(NA)$otherwise(x$expr$sum())
    }
  }
}

pl_sd <- function(x, na.rm = FALSE) {
  x <- check_rowwise(x)
  if (isTRUE(x$is_rowwise)) {
    if (isTRUE(na.rm)) {
      x$expr$list$eval(pl$element()$std(ddof = 1))$explode()
    } else {
      x$expr$list$eval(
        pl$when(pl$element()$has_nulls())$then(NA)$otherwise(
          pl$element()$std(ddof = 1)
        )
      )$explode()
    }
  } else {
    if (isTRUE(na.rm)) {
      x$expr$std(ddof = 1)
    } else {
      pl$when(x$expr$has_nulls())$then(NA)$otherwise(x$expr$std(ddof = 1))
    }
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
  expr_uses_col <- expr_uses_col_from_dots(...)
  new_vars <- new_vars_from_dots(...)
  caller <- caller_from_dots(...)
  dots <- clean_dots(...)

  x <- polars::pl$col(deparse(substitute(x)))

  if (!".default" %in% names(dots)) {
    dots[[length(dots) + 1]] <- c(".default" = NA)
  }

  out <- NULL
  for (y in seq_along(dots)) {
    if (y == length(dots)) {
      otw <- translate_expr(
        .data,
        dots[[y]],
        new_vars = new_vars,
        env = env,
        caller = caller,
        expr_uses_col = expr_uses_col
      )
      out <- out$otherwise(otw)
      next
    }
    lhs <- translate_expr(
      .data,
      dots[[y]][[2]],
      new_vars = new_vars,
      env = env,
      caller = caller,
      expr_uses_col = expr_uses_col
    )
    rhs <- translate_expr(
      .data,
      dots[[y]][[3]],
      new_vars = new_vars,
      env = env,
      caller = caller,
      expr_uses_col = expr_uses_col
    )
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
  expr_uses_col <- expr_uses_col_from_dots(...)
  new_vars <- new_vars_from_dots(...)
  caller <- caller_from_dots(...)
  dots <- clean_dots(...)

  if (!".default" %in% names(dots)) {
    dots[[length(dots) + 1]] <- c(".default" = NA)
  }

  out <- NULL
  for (y in seq_along(dots)) {
    if (y == length(dots)) {
      otw <- translate_expr(
        .data,
        dots[[y]],
        new_vars = new_vars,
        env = env,
        caller = caller,
        expr_uses_col = expr_uses_col
      )
      out <- out$otherwise(otw)
      next
    }
    lhs <- translate_expr(
      .data,
      dots[[y]][[2]],
      new_vars = new_vars,
      env = env,
      caller = caller,
      expr_uses_col = expr_uses_col
    )
    rhs <- translate_expr(
      .data,
      dots[[y]][[3]],
      new_vars = new_vars,
      env = env,
      caller = caller,
      expr_uses_col = expr_uses_col
    )

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
    cli_abort(
      "{.code ...} is absent, but must be supplied.",
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

pl_dense_rank_dplyr <- function(x) {
  x$rank(method = "dense")
}

pl_diff <- function(x, lag = 1, differences = 1, ...) {
  check_empty_dots(...)
  if (!is.null(differences) && length(differences) == 1 && differences != 1) {
    cli_abort(
      "polars doesn't support {.code diff()} if argument `differences` is not equal to 1.",
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
  expr_uses_col <- expr_uses_col_from_dots(...)
  new_vars <- new_vars_from_dots(...)
  caller <- caller_from_dots(...)

  cond <- translate_expr(
    .data,
    enexpr(cond),
    new_vars = new_vars,
    env = env,
    caller = caller,
    expr_uses_col = expr_uses_col
  )
  yes <- translate_expr(
    .data,
    enexpr(yes),
    new_vars = new_vars,
    env = env,
    caller = caller,
    expr_uses_col = expr_uses_col
  )
  no <- translate_expr(
    .data,
    enexpr(no),
    new_vars = new_vars,
    env = env,
    caller = caller,
    expr_uses_col = expr_uses_col
  )
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

pl_lag_dplyr <- function(x, n = 1, default = NULL, order_by = NULL, ...) {
  check_empty_dots(...)
  if (!is.null(default)) {
    out <- x$shift(n, fill_value = default)
  } else {
    out <- x$shift(n)
  }
  if (!is.null(order_by)) {
    attr(out, "order_by") <- order_by
  }
  out
}

pl_last_dplyr <- function(x, ...) {
  check_empty_dots(...)
  x$last()
}

pl_lead_dplyr <- function(x, n = 1, default = NULL, order_by = NULL, ...) {
  check_empty_dots(...)
  if (!is.null(default)) {
    out <- x$shift(-n, fill_value = default)
  } else {
    out <- x$shift(-n)
  }
  if (!is.null(order_by)) {
    attr(out, "order_by") <- order_by
  }
  out
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
    cli_abort(
      "{.code ...} is absent, but must be supplied.",
      call = env_from_dots(...)
    )
  }
  if (isTRUE(na.rm)) {
    # https://stackoverflow.com/a/78888889/11598948
    check_is_null <- lapply(dots, function(x) x$is_null())
    check_any_is_null <- call2(pl$any_horizontal, !!!check_is_null) |>
      eval_bare()
    pl$struct(dots)$filter(check_any_is_null$not())$n_unique()
  } else {
    pl$struct(dots)$n_unique()
  }
}

pl_nth_dplyr <- function(x, n, ...) {
  if (length(n) > 1) {
    cli_abort(
      paste0("{.code n} must have size 1, not size {length(n)}."),
      call = env_from_dots(...)
    )
  }
  if (is.na(n)) {
    cli_abort("{.code n} cannot be `NA`.", call = env_from_dots(...))
  }
  if (as.integer(n) != n) {
    cli_abort("{.code n} must be an integer.", call = env_from_dots(...))
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

pl_rev <- function(x) {
  x$reverse()
}

pl_round <- function(x, digits = 0, ...) {
  check_empty_dots(...)
  x$round(decimals = digits)
}

pl_row_number_dplyr <- function(x = NULL) {
  if (is.null(x)) {
    pl$int_range(start = 1, pl$len() + 1)
  } else {
    x$rank(method = "ordinal")
  }
}

pl_sample <- function(x, size = NULL, replace = FALSE, ...) {
  check_empty_dots(...)
  # TODO: how should I handle seed, given that R sample() doesn't have this arg
  x$sample(n = size, with_replacement = replace, shuffle = TRUE)
}

pl_seq <- function(from = 1, to = 1, by = NULL, ...) {
  check_empty_dots(...)
  by <- by %||% 1
  pl$int_range(start = from, end = to + 1, step = by)
}

pl_seq_len <- function(length.out) {
  length.out <- polars_expr_to_r(length.out)
  if (length.out < 0) {
    cli_abort("{.code length.out} must be a non-negative integer.")
  }
  pl$int_range(start = 1, end = length.out + 1, step = 1)
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

pl_var <- function(x, na.rm = FALSE, ...) {
  check_empty_dots(...)
  if (isTRUE(na.rm)) {
    x$var(ddof = 1)
  } else {
    pl$when(x$has_nulls())$then(NA)$otherwise(x$var(ddof = 1))
  }
}

pl_which.max <- function(x, ...) {
  check_empty_dots(...)
  (x$arg_max() + 1)$first()
}

pl_which.min <- function(x, ...) {
  check_empty_dots(...)
  (x$arg_min() + 1)$first()
}
