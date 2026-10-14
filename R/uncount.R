#' Uncount a Data/LazyFrame
#'
#' This duplicates rows according to a weighting variable (or expression). This
#' is the opposite of `count()`.
#'
#' @param data A Polars Data/LazyFrame
#' @param weights Nonnegative, integer-valued weights evaluated in the context
#'   of `data`, within groups for grouped data. Zero weights remove rows.
#' @inheritParams rlang::check_dots_empty0
#' @param .remove If `TRUE`, and weights is the name of a column in data, then
#' this column is removed.
#' @param .id Supply a string to create a variable numbering the copies of
#'   each original row, starting at one. An existing column is overwritten.
#' @return A Data/LazyFrame with rows repeated in their original order.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars::pl$DataFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))
#' test
#'
#' uncount(test, n)
#'
#' uncount(test, n, .id = "id")
#'
#' # using constants
#' uncount(test, 2)
#'
#' # using expressions
#' uncount(test, 2 / n)
uncount.polars_data_frame <- function(
  data,
  weights,
  ...,
  .remove = TRUE,
  .id = NULL
) {
  data <- tag_frame(data, substitute(data))
  check_dots_empty()
  check_bool(.remove)
  check_name(.id, allow_null = TRUE)
  weights_quo <- enquo(weights)
  grps <- attributes(data)$pl_grps
  mo <- attributes(data)$maintain_grp_order %||% FALSE

  # Follow mutate()'s collision handling without overwriting any user column.
  temp <- "__tidypolars_uncount__"
  while (temp %in% c(names(data), .id)) {
    temp <- paste0("_", temp)
  }
  out <- eval_tidy(
    expr((!!mutate)(!!data, !!temp := !!weights_quo)),
    env = quo_get_env(weights_quo)
  )
  # The weights are now in temp; avoid repeating a column that will be removed.
  if (.remove && quo_is_symbol(weights_quo)) {
    weight_name <- as_string(get_expr(weights_quo))
    if (weight_name %in% names(data)) {
      out <- out$drop(weight_name)
    }
  }
  dtype <- out$collect_schema()[[temp]]
  if (
    !dtype$is_numeric() &&
      !inherits(dtype, "polars_dtype_boolean") &&
      !inherits(dtype, "polars_dtype_null")
  ) {
    cli_abort("{.arg weights} must be numeric or logical.")
  }
  weights_expr <- pl$col(temp)$cast(pl$Float64)
  valid <- weights_expr$is_not_null()$and(
    weights_expr$is_finite()
  )$and(
    weights_expr$ge(0)
  )$and(
    weights_expr$le(.Machine$integer.max)
  )$and(
    weights_expr$eq(weights_expr$floor())
  )
  # A strict unsigned cast rejects the sentinel for every invalid weight.
  # Check before casting: integer casts alone silently truncate fractions.
  weights_expr <- pl$when(valid)$then(weights_expr)$otherwise(-1)$cast(
    pl$UInt32
  )$cast(pl$Int32)
  # Exploding only the copy indices duplicates all other columns unchanged.
  out <- with_polars_errors(
    out$with_columns(
      pl$int_ranges(0L, weights_expr, dtype = pl$Int32)$alias(temp)
    )$explode(temp, empty_as_null = FALSE)
  )

  if (!is.null(.id)) {
    out <- out$with_columns((pl$col(temp) + 1L)$alias(.id))
  }
  out <- out$drop(temp)
  if (!is.null(grps)) {
    out <- group_by(
      out,
      all_of(intersect(grps, names(out))),
      maintain_order = mo
    )
  }
  add_tidypolars_class(out)
}

#' @rdname uncount.polars_data_frame
#' @export
uncount.polars_lazy_frame <- uncount.polars_data_frame
