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

pl_ceiling <- function(x, ...) {
  check_empty_dots(...)
  x$ceil()
}

pl_cos <- function(x, ...) {
  check_empty_dots(...)
  x$cos()
}

pl_cosh <- function(x, ...) {
  check_empty_dots(...)
  x$cosh()
}

pl_cummax <- function(x, ...) {
  check_empty_dots(...)
  # Once a missing value is seen, keep a TRUE mask for all following rows.
  has_seen_na <- x$is_null()$cum_max()
  # Replace cumulative results with NA from the first missing value onward.
  pl$when(has_seen_na)$then(pl$lit(NA))$otherwise(x$cum_max())
}

pl_cummin <- function(x, ...) {
  check_empty_dots(...)
  has_seen_na <- x$is_null()$cum_max()
  pl$when(has_seen_na)$then(pl$lit(NA))$otherwise(x$cum_min())
}

pl_cumprod <- function(x, ...) {
  check_empty_dots(...)
  has_seen_na <- x$is_null()$cum_max()
  pl$when(has_seen_na)$then(pl$lit(NA))$otherwise(x$cum_prod())
}

pl_cumsum <- function(x, ...) {
  check_empty_dots(...)
  has_seen_na <- x$is_null()$cum_max()
  pl$when(has_seen_na)$then(pl$lit(NA))$otherwise(x$cum_sum())
}

# TODO: this is not tested anymore because it requires reframe():
# - the number of output values is not the same as input values, so we can't use
#   mutate()
# - as of dplyr 1.2.0, summarize() errors if a function returns more than one row
#   per group, which is the case here.

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

pl_ifelse <- function(test, yes, no, .data, ...) {
  check_empty_dots(...)
  env <- env_from_dots(...)
  expr_uses_col <- expr_uses_col_from_dots(...)
  new_vars <- new_vars_from_dots(...)
  caller <- caller_from_dots(...)

  test <- translate_expr(
    .data,
    enexpr(test),
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
  pl$when(test)$then(yes)$otherwise(no)
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

pl_mode <- function(x, ...) {
  check_empty_dots(...)
  x$mode()
}

pl_rank <- function(x, na.last = TRUE, ties.method = "average", ...) {
  check_empty_dots(...)

  # Validate na.last: only TRUE / FALSE / "keep" are supported.
  if (!isTRUE(na.last) && !isFALSE(na.last) && !identical(na.last, "keep")) {
    cli_abort("`na.last` must be `TRUE`, `FALSE`, or `\"keep\"`.")
  }

  ties.method <- rlang::arg_match0(
    ties.method,
    values = c("average", "first", "last", "random", "max", "min")
  )

  # Core ranking logic
  out <- NULL
  if (ties.method == "first") {
    out <- x$rank(method = "ordinal")
  } else if (ties.method == "last") {
    out <- x$rank(method = "max") +
      x$rank(method = "min") -
      x$rank(method = "ordinal")
  } else {
    out <- x$rank(method = ties.method)
  }

  # na.last = "keep"
  if (identical(na.last, "keep")) {
    return(out)
  }

  is_null <- x$is_null()
  null_rank <- is_null$cast(pl$Int64)$cum_sum()
  n_null <- is_null$cast(pl$Int64)$sum()

  if (isTRUE(na.last)) {
    # Keep value ranks unchanged and append NAs as distinct ranks at the end.
    n_non_null <- x$len() - n_null
    return(pl$when(is_null)$then(n_non_null + null_rank)$otherwise(out))
  }

  if (isFALSE(na.last)) {
    # Put NAs first with distinct ranks, then shift value ranks by NA count.
    return(pl$when(is_null)$then(null_rank)$otherwise(out + n_null))
  }
}

pl_rev <- function(x) {
  x$reverse()
}

pl_round <- function(x, digits = 0, ...) {
  check_empty_dots(...)
  x$round(decimals = digits)
}

pl_sample <- function(x, size = NULL, replace = FALSE, ...) {
  check_empty_dots(...)
  # TODO: how should I handle seed, given that R sample() doesn't have this arg
  out <- x$sample(n = size, with_replacement = replace, shuffle = TRUE)
  if (is.null(size) || size == 1) {
    out <- out$first()
  }
  out
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

pl_seq <- function(from = 1, to = 1, by = NULL, ...) {
  check_empty_dots(...)
  by <- by %||% 1
  out <- pl$int_range(start = from, end = to + 1, step = by)
  if ((to - from) == 1) {
    out <- out$first()
  }
  out
}

pl_seq_len <- function(length.out) {
  length.out <- polars_expr_to_r(length.out)
  check_number_whole(length.out)

  if (length.out < 0) {
    cli_abort("{.code length.out} must be a non-negative integer.")
  }
  out <- pl$int_range(start = 1, end = length.out + 1, step = 1)
  if (length.out == 1) {
    out <- out$first()
  }
  out
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

pl_sort <- function(x, decreasing = FALSE, na.last, ...) {
  check_empty_dots(...)
  check_bool(decreasing, allow_na = FALSE)
  check_bool(na.last, allow_na = FALSE)

  x$sort(descending = decreasing, nulls_last = na.last)
}

pl_sqrt <- function(x, ...) {
  check_empty_dots(...)
  x$sqrt()
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

# Utils ---------------------------------------------------

# Extract the "from" and "to" components from the dots in replace_/recode_*()
extract_from_to <- function(dots, env) {
  # Start by checking that each element is a formula
  not_length_2 <- which(vapply(dots, \(x) length(x) != 2, logical(1)))
  if (length(not_length_2) > 0) {
    n <- length(not_length_2)
    cli_abort(
      "{qty(n)} Case{?s} {.code {not_length_2}} must be {qty(n)} {?a/} two-sided {qty(n)} formula{?s}.",
      call = env
    )
  }

  # Extract LHS and RHS and ensure there is no NULL on either side
  from <- lapply(dots, `[[`, 1)
  any_null_from <- any(vapply(
    from,
    function(x) identical(x, list(NULL)),
    logical(1)
  ))
  if (isTRUE(any_null_from)) {
    cli_abort(
      "Cannot have {.code NULL} in {.arg ...} or {.arg from}.",
      call = env
    )
  }
  from <- unlist(from, use.names = FALSE)

  to <- lapply(dots, `[[`, 2)
  any_null_to <- any(vapply(
    to,
    function(x) identical(x, list(NULL)),
    logical(1)
  ))
  if (isTRUE(any_null_to)) {
    cli_abort(
      "Cannot have {.code NULL} in {.arg ...} or {.arg to}.",
      call = env
    )
  }
  to <- unlist(to, use.names = FALSE)

  list(from = from, to = to)
}
