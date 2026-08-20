# All these functions should be internal, the user doesn't need to access them

pl_abs <- function(x) {
  x$abs()
}

pl_all <- function(..., na.rm = FALSE) {
  dots <- clean_dots(...)
  env <- env_from_dots(...)
  x <- check_rowwise(...)
  na.rm <- polars_expr_to_r(na.rm)
  if (length(dots) == 0) {
    cli_abort(
      "{.code ...} is absent, but must be supplied.",
      call = env
    )
  }
  if (isTRUE(x$is_rowwise)) {
    return(x$expr$list$eval(pl$element()$all())$explode(empty_as_null = TRUE))
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
  na.rm <- polars_expr_to_r(na.rm)
  if (length(dots) == 0) {
    cli_abort(
      "{.code ...} is absent, but must be supplied.",
      call = env
    )
  }
  if (isTRUE(x$is_rowwise)) {
    return(x$expr$list$eval(pl$element()$any())$explode(empty_as_null = TRUE))
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

pl_anyNA <- function(x, recursive = FALSE) {
  if (!missing(recursive)) {
    cli_abort(
      "Argument {.code recursive} is not supported by {.pkg tidypolars}."
    )
  }
  x$has_nulls()
}

pl_anyDuplicated <- function(x, incomparables = FALSE, fromLast = FALSE, ...) {
  check_empty_dots(...)

  fromLast <- polars_expr_to_r(fromLast)
  check_bool(fromLast)

  is_dup <- is_duplicated(x, incomparables, fromLast)
  indices <- is_dup$arg_true()
  index <- if (fromLast) {
    indices$last()
  } else {
    indices$first()
  }

  (index + 1)$fill_null(0)
}

pl_acos <- function(x) {
  x$arccos()
}

pl_acosh <- function(x) {
  x$arccosh()
}

pl_asin <- function(x) {
  x$arcsin()
}

pl_asinh <- function(x) {
  x$arcsinh()
}

pl_atan <- function(x) {
  x$arctan()
}

pl_atanh <- function(x) {
  x$arctanh()
}

pl_ceiling <- function(x) {
  x$ceil()
}

pl_cos <- function(x) {
  x$cos()
}

pl_cosh <- function(x) {
  x$cosh()
}

pl_cummax <- function(x) {
  # Once a missing value is seen, keep a TRUE mask for all following rows.
  has_seen_na <- x$is_null()$cum_max()
  # Replace cumulative results with NA from the first missing value onward.
  pl$when(has_seen_na)$then(pl$lit(NA))$otherwise(x$cum_max())
}

pl_cummin <- function(x) {
  has_seen_na <- x$is_null()$cum_max()
  pl$when(has_seen_na)$then(pl$lit(NA))$otherwise(x$cum_min())
}

pl_cumprod <- function(x) {
  has_seen_na <- x$is_null()$cum_max()
  pl$when(has_seen_na)$then(pl$lit(NA))$otherwise(x$cum_prod())
}

pl_cumsum <- function(x) {
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
  lag <- polars_expr_to_r(lag)
  differences <- polars_expr_to_r(differences)
  if (!is.null(differences) && length(differences) == 1 && differences != 1) {
    cli_abort(
      "polars doesn't support {.code diff()} if argument `differences` is not equal to 1.",
      call = env_from_dots(...)
    )
  }
  x$diff(n = lag, null_behavior = "drop")
}

pl_duplicated <- function(x, incomparables = FALSE, fromLast = FALSE, ...) {
  check_empty_dots(...)

  fromLast <- polars_expr_to_r(fromLast)
  check_bool(fromLast)
  is_duplicated(x, incomparables, fromLast)
}

pl_exp <- function(x) {
  x$exp()
}

pl_floor <- function(x) {
  x$floor()
}

pl_ifelse <- function(test, yes, no, .data, ..., missing = NULL) {
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
  missing_expr <- enexpr(missing)
  if (is_null(missing_expr)) {
    missing_expr <- pl$lit(NA)
  } else {
    missing_expr <- translate_expr(
      .data,
      missing_expr,
      new_vars = new_vars,
      env = env,
      caller = caller,
      expr_uses_col = expr_uses_col
    )
  }

  pl$when(test$is_null())$then(missing_expr)$when(test)$then(yes)$otherwise(no)
}

pl_is.finite <- function(x) {
  pl$when(x$is_null())$then(pl$lit(FALSE))$otherwise(x$is_finite())
}

pl_is.infinite <- function(x) {
  pl$when(x$is_null())$then(pl$lit(FALSE))$otherwise(x$is_infinite())
}

pl_is.na <- function(x) {
  # Note: in R, is.na(NaN) is true, but I can't do the same here because polars
  # doesn't accept non-numeric inputs for $is_nan().
  x$is_null()
}

pl_is.nan <- function(x) {
  pl$when(x$is_null())$then(pl$lit(FALSE))$otherwise(x$is_nan())
}

pl_length <- function(x) {
  x$len()
}

pl_log <- function(x, base = exp(1)) {
  base <- polars_expr_to_r(base)
  x$log(base = base)
}

pl_log10 <- function(x) {
  x$log10()
}

pl_max <- function(..., na.rm = FALSE) {
  na.rm <- polars_expr_to_r(na.rm)
  check_bool(na.rm)
  x <- check_rowwise_dots(...)
  if (isTRUE(x$is_rowwise)) {
    element <- pl$element()
    out <- element$max()
    if (!na.rm) {
      out <- pl$when(element$has_nulls())$then(NA)$otherwise(out)
    }
    return(x$expr$list$eval(out)$explode(empty_as_null = TRUE))
  }

  aggregate_exprs(
    x$expr,
    \(x) x$max(),
    \(x) pl$max_horizontal(!!!x),
    na.rm
  )
}

pl_mean <- function(x, na.rm = FALSE, ...) {
  check_empty_dots(...)
  na.rm <- polars_expr_to_r(na.rm)
  check_bool(na.rm)
  x <- check_rowwise(x, ...)
  is_rowwise <- isTRUE(x$is_rowwise)
  expr <- if (is_rowwise) pl$element() else x$expr

  out <- expr$mean()
  if (!na.rm) {
    out <- pl$when(expr$has_nulls())$then(NA)$otherwise(out)
  }

  if (is_rowwise) {
    x$expr$list$eval(out)$explode(empty_as_null = TRUE)
  } else {
    out
  }
}

pl_median <- function(x, na.rm = FALSE, ...) {
  check_empty_dots(...)
  na.rm <- polars_expr_to_r(na.rm)
  check_bool(na.rm)
  x <- check_rowwise(x, ...)
  is_rowwise <- isTRUE(x$is_rowwise)
  expr <- if (is_rowwise) pl$element() else x$expr
  out <- expr$median()
  if (!na.rm) {
    out <- pl$when(expr$has_nulls())$then(NA)$otherwise(out)
  }

  if (is_rowwise) {
    x$expr$list$eval(out)$explode(empty_as_null = TRUE)
  } else {
    out
  }
}

pl_min <- function(..., na.rm = FALSE) {
  na.rm <- polars_expr_to_r(na.rm)
  check_bool(na.rm)
  x <- check_rowwise_dots(...)
  if (isTRUE(x$is_rowwise)) {
    element <- pl$element()
    out <- element$min()
    if (!na.rm) {
      out <- pl$when(element$has_nulls())$then(NA)$otherwise(out)
    }
    return(x$expr$list$eval(out)$explode(empty_as_null = TRUE))
  }

  aggregate_exprs(
    x$expr,
    \(x) x$min(),
    \(x) pl$min_horizontal(!!!x),
    na.rm
  )
}

pl_rank <- function(x, na.last = TRUE, ties.method = "average", ...) {
  check_empty_dots(...)

  na.last <- polars_expr_to_r(na.last)
  ties.method <- polars_expr_to_r(ties.method)

  # Validate na.last: only TRUE / FALSE / "keep" are supported.
  if (!isTRUE(na.last) && !isFALSE(na.last) && !identical(na.last, "keep")) {
    cli_abort("`na.last` must be `TRUE`, `FALSE`, or `\"keep\"`.")
  }

  ties.method <- rlang::arg_match0(
    ties.method,
    values = c("average", "first", "last", "random", "max", "min")
  )

  # Core ranking logic
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
  digits <- polars_expr_to_r(digits)
  x$round(decimals = digits)
}

pl_sample <- function(x, size = NULL, replace = FALSE, ...) {
  check_empty_dots(...)
  size <- polars_expr_to_r(size)
  replace <- polars_expr_to_r(replace)
  # WARNING: random seed is not supported and cannot take effect.
  if (missing(size) || is.null(size)) {
    size <- x$len()
  }
  if (!is_polars_expr(size)) {
    if (!is.numeric(size) || size <= 0 || size %% 1 != 0) {
      cli_abort("{.code size} must be a positive integer.")
    }
    size <- as.integer(size)
  }

  out <- x$sample(n = size, with_replacement = replace, shuffle = TRUE)

  if (!is_polars_expr(size) && size == 1L) {
    out <- out$first()
  }
  out
}

pl_sd <- function(x, na.rm = FALSE, ...) {
  check_empty_dots(...)
  na.rm <- polars_expr_to_r(na.rm)
  check_bool(na.rm)
  x <- check_rowwise(x, ...)
  is_rowwise <- isTRUE(x$is_rowwise)
  expr <- if (is_rowwise) pl$element() else x$expr
  out <- expr$std(ddof = 1)
  if (!na.rm) {
    out <- pl$when(expr$has_nulls())$then(NA)$otherwise(out)
  }

  if (is_rowwise) {
    x$expr$list$eval(out)$explode(empty_as_null = TRUE)
  } else {
    out
  }
}

pl_seq <- function(from = 1, to = 1, by = NULL, ...) {
  check_empty_dots(...)
  by <- polars_expr_to_r(by)
  to <- polars_expr_to_r(to)
  from <- polars_expr_to_r(from)

  if (is.null(by)) {
    by <- if (to >= from) {
      1
    } else {
      -1
    }
  }

  if (by == 0) {
    if (to == from) {
      return(pl$lit(from))
    }
    cli_abort("{.arg by} must not be zero.")
  }
  if ((to - from) * by < 0) {
    cli_abort("Wrong sign in {.arg by} argument.")
  }

  out <- pl$int_range(start = from, end = to + sign(by), step = by)
  if (abs(to - from) < abs(by)) {
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

pl_sign <- function(x) {
  x$sign()
}

pl_sin <- function(x) {
  x$sin()
}

pl_sinh <- function(x) {
  x$sinh()
}

pl_sort <- function(x, decreasing = FALSE, na.last, ...) {
  check_empty_dots(...)
  decreasing <- polars_expr_to_r(decreasing)
  if (!missing(na.last)) {
    na.last <- polars_expr_to_r(na.last)
  }
  check_bool(decreasing, allow_na = FALSE)
  check_bool(na.last, allow_na = FALSE)

  x$sort(descending = decreasing, nulls_last = na.last)
}

pl_sqrt <- function(x) {
  x$sqrt()
}

pl_sum <- function(..., na.rm = FALSE) {
  na.rm <- polars_expr_to_r(na.rm)
  check_bool(na.rm)
  x <- check_rowwise_dots(...)
  if (isTRUE(x$is_rowwise)) {
    element <- pl$element()
    out <- element$sum()
    if (!na.rm) {
      out <- pl$when(element$has_nulls())$then(NA)$otherwise(out)
    }
    return(x$expr$list$eval(out)$explode(empty_as_null = TRUE))
  }

  aggregate_exprs(
    x$expr,
    \(x) x$sum(),
    \(x) Reduce(`+`, x),
    na.rm
  )
}

pl_tan <- function(x) {
  x$tan()
}

pl_tanh <- function(x) {
  x$tanh()
}

pl_trunc <- function(x, ...) {
  check_empty_dots(...)
  x$truncate(decimals = 0)
}

pl_unique <- function(x, ...) {
  check_empty_dots(...)
  x$unique()
}

pl_var <- function(x, y = NULL, na.rm = FALSE, use, ...) {
  check_empty_dots(...)
  na.rm <- polars_expr_to_r(na.rm)
  check_bool(na.rm)

  if (
    identical(y, list(NULL)) ||
      (is_polars_expr(y) && isTRUE(y$meta$eq(pl$lit(NULL))))
  ) {
    y <- NULL
  }

  if (missing(use)) {
    use <- if (na.rm) "na.or.complete" else "everything"
  } else {
    use <- polars_expr_to_r(use)
    check_string(use)
    use <- match.arg(
      use,
      c(
        "all.obs",
        "complete.obs",
        "pairwise.complete.obs",
        "everything",
        "na.or.complete"
      )
    )
  }

  remove_nulls <- use %in%
    c(
      "complete.obs",
      "pairwise.complete.obs",
      "na.or.complete"
    )

  if (is.null(y)) {
    expr <- if (remove_nulls) x$drop_nulls() else x
    out <- expr$var(ddof = 1)
    if (!remove_nulls) {
      out <- pl$when(x$has_nulls())$then(NA)$otherwise(out)
    }
    return(out)
  }

  if (remove_nulls) {
    complete <- x$is_not_null() & y$is_not_null()
    x <- x$filter(complete)
    y <- y$filter(complete)
  }

  n <- x$len()
  out <- ((x - x$mean()) * (y - y$mean()))$sum() / (n - 1)
  out <- pl$when(n < 2)$then(NA)$otherwise(out)
  if (!remove_nulls) {
    out <- pl$when(x$has_nulls() | y$has_nulls())$then(NA)$otherwise(out)
  }
  out
}

pl_which.max <- function(x) {
  (x$arg_max() + 1)$first()
}

pl_which.min <- function(x) {
  (x$arg_min() + 1)$first()
}

# Utils ---------------------------------------------------

aggregate_exprs <- function(exprs, aggregate, combine, na.rm) {
  values <- lapply(exprs, aggregate)
  out <- if (length(values) == 1) values[[1]] else combine(values)

  if (na.rm) {
    return(out)
  }

  has_nulls <- Reduce(`|`, lapply(exprs, \(x) x$has_nulls()))
  pl$when(has_nulls)$then(NA)$otherwise(out)
}

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
  from <- lapply(from, polars_expr_to_r)
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
  to <- lapply(to, polars_expr_to_r)
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

# Flag duplicated values in a column. Shared by pl_duplicated() and
# pl_anyDuplicated().
is_duplicated <- function(x, incomparables, fromLast) {
  dupes <- if (fromLast) {
    x$is_last_distinct()$not()
  } else {
    x$is_first_distinct()$not()
  }

  # Handle incomparables. If incomparables is NULL, list(NULL), or a polars
  # expression that evaluates to NULL, then we don't need to do anything.
  if (
    is.null(incomparables) ||
      identical(incomparables, list(NULL)) ||
      (is_polars_expr(incomparables) &&
        isTRUE(incomparables$meta$eq(pl$lit(NULL))))
  ) {
    incomparables <- FALSE
  } else {
    incomparables <- polars_expr_to_r(incomparables)
    if (!is_polars_expr(incomparables) && length(incomparables) == 0L) {
      incomparables <- FALSE
    }
  }

  if (isFALSE(incomparables)) {
    return(dupes)
  }

  if (is_polars_expr(incomparables)) {
    # `incomparables` couldn't be converted back to an R vector (e.g. it is
    # a translated call like `as.Date("2024-01-01")`).
    incomparable <- x$is_in(incomparables$implode(), nulls_equal = TRUE)
  } else if (is.logical(incomparables) && all(is.na(incomparables))) {
    # `pl$lit(list(NA))` is List(Boolean) and can't be used in is_in()
    # with a non-boolean column.
    incomparable <- x$is_null()
  } else {
    incomparable <- x$is_in(pl$lit(list(incomparables)), nulls_equal = TRUE)
  }

  dupes & incomparable$not()
}
