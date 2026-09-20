pl_between_dplyr <- function(x, left, right, ...) {
  left <- polars_expr_to_r(left)
  right <- polars_expr_to_r(right)
  check_empty_dots(...)
  x$is_between(lower_bound = left, upper_bound = right, closed = "both")
}

pl_case_match_dplyr <- function(x, ...) {
  env <- env_from_dots(...)
  dots <- clean_dots(...)

  from_to <- extract_formula_case(dots, env)

  out <- NULL
  for (i in seq_along(from_to$from)) {
    lhs <- from_to$from[[i]] |>
      as_lit_expr()
    rhs <- from_to$to[[i]] |>
      as_lit_expr()

    if (is.null(out)) {
      out <- pl$when(x$is_in(lhs$implode()))$then(rhs)
    } else {
      out <- out$when(x$is_in(lhs$implode()))$then(rhs)
    }
  }
  otw <- from_to$default |>
    as_lit_expr()

  out <- out$otherwise(otw)

  out
}

pl_case_when_dplyr <- function(...) {
  env <- env_from_dots(...)
  dots <- clean_dots(...)

  from_to <- extract_formula_case(dots, env)

  out <- NULL
  for (i in seq_along(from_to$from)) {
    lhs <- from_to$from[[i]] |>
      as_lit_expr()
    rhs <- from_to$to[[i]] |>
      as_lit_expr()

    if (is.null(out)) {
      out <- pl$when(lhs)$then(rhs)
    } else {
      out <- out$when(lhs)$then(rhs)
    }
  }
  otw <- from_to$default |>
    as_lit_expr()

  out <- out$otherwise(otw)
  out
}

pl_coalesce_dplyr <- function(...) {
  # pl$coalesce() doesn't accept a list
  call2(pl$coalesce, !!!clean_dots(...)) |> eval_bare()
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
  dots <- pl$struct(!!!dots)
  dots$rle_id() + 1
}

pl_dense_rank_dplyr <- function(x) {
  x$rank(method = "dense")
}

pl_desc_dplyr <- function(x) {
  attr(x, "descending") <- TRUE
  x
}

pl_first_dplyr <- function(
  x,
  order_by = NULL,
  default = NULL,
  na_rm = FALSE,
  ...
) {
  if (missing(order_by) && missing(default) && missing(na_rm)) {
    check_empty_dots(...)
    return(x$first())
  }
  pl_nth_dplyr(
    x,
    1L,
    order_by = order_by,
    default = default,
    na_rm = na_rm,
    ...
  )
}

pl_lag_dplyr <- function(x, n = 1, default = NULL, order_by = NULL, ...) {
  check_empty_dots(...)
  n <- polars_expr_to_r(n)
  default <- polars_expr_to_r(default)
  order_by <- polars_expr_to_r(order_by)
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

pl_last_dplyr <- function(
  x,
  order_by = NULL,
  default = NULL,
  na_rm = FALSE,
  ...
) {
  if (missing(order_by) && missing(default) && missing(na_rm)) {
    check_empty_dots(...)
    return(x$last())
  }
  pl_nth_dplyr(
    x,
    -1L,
    order_by = order_by,
    default = default,
    na_rm = na_rm,
    ...
  )
}

pl_lead_dplyr <- function(x, n = 1, default = NULL, order_by = NULL, ...) {
  check_empty_dots(...)
  n <- polars_expr_to_r(n)
  default <- polars_expr_to_r(default)
  order_by <- polars_expr_to_r(order_by)
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

pl_min_rank_dplyr <- function(x) {
  x$rank(method = "min")
}

pl_n_dplyr <- function() {
  pl$len()
}

pl_na_if_dplyr <- function(x, y) {
  if (length(y) == 1 && !is_polars_expr(y) && is.na(y)) {
    pl$when(x$is_null())$then(pl$lit(NA))$otherwise(x)
  } else {
    pl$when(x == y)$then(pl$lit(NA))$otherwise(x)
  }
}

pl_n_distinct_dplyr <- function(..., na.rm = FALSE) {
  dots <- clean_dots(...)
  na.rm <- polars_expr_to_r(na.rm)
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
    pl$struct(!!!dots)$filter(check_any_is_null$not())$n_unique()
  } else {
    pl$struct(!!!dots)$n_unique()
  }
}

pl_near_dplyr <- function(x, y, tol = .Machine$double.eps^0.5) {
  tol <- polars_expr_to_r(tol)
  (x - y)$abs() < tol
}

pl_nth_dplyr <- function(
  x,
  n,
  order_by = NULL,
  default = NULL,
  na_rm = FALSE,
  ...
) {
  check_empty_dots(...)
  n <- polars_expr_to_r(n)
  if (length(n) > 1) {
    cli_abort(
      paste0("{.code n} must have size 1, not size {length(n)}."),
      call = env_from_dots(...)
    )
  }
  check_number_whole(n, allow_na = FALSE)
  na_rm <- polars_expr_to_r(na_rm)
  check_bool(na_rm)

  # The translator wraps explicit NULL arguments in a list.
  if (
    identical(order_by, list(NULL)) ||
      (is_polars_expr(order_by) && order_by$meta$eq(pl$lit(NULL)))
  ) {
    order_by <- NULL
  }
  if (
    identical(default, list(NULL)) ||
      (is_polars_expr(default) && default$meta$eq(pl$lit(NULL)))
  ) {
    default <- NULL
  }

  if (!is.null(order_by)) {
    descending <- isTRUE(attr(order_by, "descending"))
    # Sort NaN keys alongside nulls, while preserving strings such as "NaN".
    order_by <- pl$when(nth_is_missing(order_by))$then(pl$lit(NULL))$otherwise(
      order_by
    )
    x <- x$sort_by(
      order_by,
      descending = descending,
      nulls_last = TRUE,
      maintain_order = TRUE
    )
  }
  if (na_rm) {
    x <- x$drop_nulls()$drop_nans()
  }

  # 0-indexed
  index <- if (n > 0) {
    n - 1
  } else if (n == 0) {
    # R's zero index is always out of bounds; preserve the input dtype.
    x$len()
  } else {
    n
  }
  out <- x$get(index, null_on_oob = TRUE)

  # Require a scalar default and use it only out of bounds, preserving selected NAs.
  if (!is.null(default)) {
    default_r <- polars_expr_to_r(default)
    if (!is_polars_expr(default_r)) {
      vctrs::vec_check_size(default_r, size = 1L)
    }
    # Enforce scalar size for column-dependent defaults at execution time too.
    default <- as_lit_expr(default)$reshape(1L)$get(0)
    out_of_bounds <- if (n == 0) pl$lit(TRUE) else x$len() < abs(n)
    out <- pl$when(out_of_bounds)$then(default)$otherwise(out)
  }
  out
}

nth_is_missing <- function(x) {
  # is_nan() rejects non-numeric inputs. Only floating-point NaNs are missing;
  # a string containing "NaN" must remain an ordinary value.
  is_float <- pl$dtype_of(x)$matches(polars::cs$float())
  x$is_null() | (is_float & x$cast(pl$Float64, strict = FALSE)$is_nan())
}

pl_recode_values_dplyr <- function(
  x,
  ...,
  from = NULL,
  to = NULL,
  default = NULL,
  unmatched,
  ptype
) {
  default <- polars_expr_to_r(default)
  default <- default %||% NA
  env <- env_from_dots(...)
  dots <- clean_dots(...)
  if (length(dots) > 0 && (!is.null(from) || !is.null(to))) {
    cli_abort(
      "Can't supply both {.arg ...} and {.arg from} / {.arg to}.",
      call = env
    )
  }
  if (!is.null(from) && is.null(to)) {
    cli_abort(
      "Specified {.arg from} but not {.arg to}.",
      call = env
    )
  }
  if (is.null(from) && !is.null(to)) {
    cli_abort(
      "Specified {.arg to} but not {.arg from}.",
      call = env
    )
  }
  if (!missing(unmatched)) {
    cli_abort(
      "Argument {.code unmatched} is not supported by {.pkg tidypolars}.",
      call = env
    )
  }
  if (!missing(ptype)) {
    cli_abort(
      "Argument {.code ptype} is not supported by {.pkg tidypolars}.",
      call = env
    )
  }

  if (length(dots) > 0) {
    from_to <- extract_from_to(dots, env)
  } else {
    from_to <- list(from = from, to = to)
  }

  x$replace_strict(
    old = from_to$from,
    new = from_to$to,
    default = default
  )
}

pl_replace_values_dplyr <- function(x, ..., from = NULL, to = NULL) {
  env <- env_from_dots(...)
  dots <- clean_dots(...)
  if (length(dots) > 0 && (!is.null(from) || !is.null(to))) {
    cli_abort(
      "Can't supply both {.arg ...} and {.arg from} / {.arg to}.",
      call = env
    )
  }

  if (!is.null(from) && is.null(to)) {
    cli_abort(
      "Specified {.arg from} but not {.arg to}.",
      call = env
    )
  }
  if (is.null(from) && !is.null(to)) {
    cli_abort(
      "Specified {.arg to} but not {.arg from}.",
      call = env
    )
  }

  if (length(dots) > 0) {
    from_to <- extract_from_to(dots, env)
  } else {
    from_to <- list(from = from, to = to)
  }

  x$replace(old = from_to$from, new = from_to$to)
}

### Very similar to pl_case_when.
### The main difference is that we put $otherwise(x) instead of $otherwise(NA).
pl_replace_when_dplyr <- function(x, ..., .data) {
  env <- env_from_dots(...)
  dots <- clean_dots(...)

  from_to <- extract_formula_case(dots, env)

  out <- NULL
  for (i in seq_along(from_to$from)) {
    lhs <- from_to$from[[i]] |>
      as_lit_expr()
    rhs <- from_to$to[[i]] |>
      as_lit_expr()

    if (is.null(out)) {
      out <- pl$when(lhs)$then(rhs)
    } else {
      out <- out$when(lhs)$then(rhs)
    }
  }

  out <- out$otherwise(x)
  out
}

pl_row_number_dplyr <- function(x = NULL) {
  if (is.null(x)) {
    pl$int_range(start = 1, pl$len() + 1)
  } else {
    x$rank(method = "ordinal")
  }
}

pl_when_all_dplyr <- function(..., na_rm, size) {
  env <- env_from_dots(...)
  dots <- clean_dots(...)
  if (!missing(na_rm)) {
    cli_abort(
      "Argument {.code na_rm} is not supported by {.pkg tidypolars}.",
      call = env
    )
  }
  if (!missing(size)) {
    cli_abort(
      "Argument {.code size} is not supported by {.pkg tidypolars}.",
      call = env
    )
  }
  pl$all_horizontal(!!!dots)
}

pl_when_any_dplyr <- function(..., na_rm, size) {
  env <- env_from_dots(...)
  dots <- clean_dots(...)
  if (!missing(na_rm)) {
    cli_abort(
      "Argument {.code na_rm} is not supported by {.pkg tidypolars}.",
      call = env
    )
  }
  if (!missing(size)) {
    cli_abort(
      "Argument {.code size} is not supported by {.pkg tidypolars}.",
      call = env
    )
  }
  pl$any_horizontal(!!!dots)
}

# Utils ---------------------------------------------------

# Extract the "from" and "to" components from the dots in case_*()
extract_formula_case <- function(dots, env) {
  # Extract the default early to avoid error "subscript out of bounds" later
  default <- dots[[".default"]] %||% pl$lit(NA)
  dots[[".default"]] <- NULL

  # Extract LHS and RHS and ensure there is no NULL on either side
  from <- lapply(dots, `[[`, 1)
  any_null_from <- any(vapply(
    from,
    function(x) identical(x, list(NULL)),
    logical(1)
  ))
  if (isTRUE(any_null_from)) {
    cli_abort(
      "Cannot have {.code NULL} in {.arg ...}.",
      call = env
    )
  }

  to <- lapply(dots, `[[`, 2)
  any_null_to <- any(vapply(
    to,
    function(x) identical(x, list(NULL)),
    logical(1)
  ))
  if (isTRUE(any_null_to)) {
    cli_abort(
      "Cannot have {.code NULL} in {.arg ...}.",
      call = env
    )
  }
  to <- unlist(to, use.names = FALSE)

  list(from = from, to = to, default = default)
}
