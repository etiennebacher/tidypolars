pl_between_dplyr <- function(x, left, right, ...) {
  check_empty_dots(...)
  x$is_between(lower_bound = left, upper_bound = right, closed = "both")
}

pl_case_match_dplyr <- function(x, ...) {
  env <- env_from_dots(...)
  expr_uses_col <- expr_uses_col_from_dots(...)
  new_vars <- new_vars_from_dots(...)
  caller <- caller_from_dots(...)
  dots <- clean_dots(...)

  from_to <- extract_formula_case(dots, env)

  out <- NULL
  for (i in seq_along(from_to$from)) {
    lhs <- from_to$from[[i]] |>
      as_polars_expr(as_lit = TRUE)
    rhs <- from_to$to[[i]] |>
      as_polars_expr(as_lit = TRUE)

    if (is.null(out)) {
      out <- polars::pl$when(x$is_in(lhs$implode()))$then(rhs)
    } else {
      out <- out$when(x$is_in(lhs$implode()))$then(rhs)
    }
  }
  otw <- from_to$default |>
    as_polars_expr(as_lit = TRUE)

  out <- out$otherwise(otw)

  out
}

pl_case_when_dplyr <- function(...) {
  env <- env_from_dots(...)
  expr_uses_col <- expr_uses_col_from_dots(...)
  new_vars <- new_vars_from_dots(...)
  caller <- caller_from_dots(...)
  dots <- clean_dots(...)

  from_to <- extract_formula_case(dots, env)

  out <- NULL
  for (i in seq_along(from_to$from)) {
    lhs <- from_to$from[[i]] |>
      as_polars_expr(as_lit = TRUE)
    rhs <- from_to$to[[i]] |>
      as_polars_expr(as_lit = TRUE)

    if (is.null(out)) {
      out <- polars::pl$when(lhs)$then(rhs)
    } else {
      out <- out$when(lhs)$then(rhs)
    }
  }
  otw <- from_to$default |>
    as_polars_expr(as_lit = TRUE)

  out <- out$otherwise(otw)
  out
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

pl_first_dplyr <- function(x, ...) {
  check_empty_dots(...)
  x$first()
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

pl_min_rank_dplyr <- function(x) {
  x$rank(method = "min")
}

pl_n_dplyr <- function(...) {
  check_empty_dots()
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
  (x - y)$abs() < tol
}

pl_nth_dplyr <- function(x, n, ...) {
  if (length(n) > 1) {
    cli_abort(
      paste0("{.code n} must have size 1, not size {length(n)}."),
      call = env_from_dots(...)
    )
  }
  check_number_whole(n, allow_na = FALSE)

  # 0-indexed
  if (n > 0) {
    n <- n - 1
  }
  x$gather(n)
}

pl_row_number_dplyr <- function(x = NULL) {
  if (is.null(x)) {
    pl$int_range(start = 1, pl$len() + 1)
  } else {
    x$rank(method = "ordinal")
  }
}

# Utils ---------------------------------------------------

# Extract the "from" and "to" components from the dots in case_*()
extract_formula_case <- function(dots, env) {
  # Extract the default early to avoid error "subscript out of bounds" later
  default <- dots[[".default"]] %||% NA
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
