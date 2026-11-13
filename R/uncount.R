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
  check_required(weights)
  check_bool(.remove)
  check_name(.id, allow_null = TRUE)

  weights_quo <- enquo(weights)
  grps <- attributes(data)$pl_grps
  mo <- attributes(data)$maintain_grp_order %||% FALSE

  schema <- data$collect_schema()

  temp <- "__tidypolars_uncount__"
  while (temp %in% c(names(schema), .id)) {
    temp <- paste0("_", temp)
  }

  weights_expr <- translate_dots(
    data,
    !!weights_quo,
    env = current_env(),
    caller = caller_env()
  )[[1]]

  if (!is.null(grps)) {
    weights_expr <- weights_expr$over(!!!grps)
  }

  # The dtype is needed to reject non-numeric weights. Getting it from an empty
  # frame with the same schema avoids resolving the query plan of `data` again.
  empty <- pl$LazyFrame()$select(
    !!!unname(Map(
      \(name, dtype) pl$lit(NULL)$cast(dtype)$alias(name),
      names(schema),
      schema
    ))
  )
  dtype <- empty$select(weights_expr)$collect_schema()[[1]]
  if (
    !dtype$is_numeric() &&
      !inherits(dtype, c("polars_dtype_boolean", "polars_dtype_null"))
  ) {
    cli_abort("{.arg weights} must be numeric or logical.")
  }

  weights_expr <- weights_expr$cast(pl$Float64)
  valid <- weights_expr$is_finite()$and(
    weights_expr$ge(0)
  )$and(
    weights_expr$le(.Machine$integer.max)
  )$and(
    weights_expr$eq(weights_expr$floor())
  )
  # False and null predicates both select the sentinel, rejected by the cast.
  # Check before casting: integer casts alone silently truncate fractions.
  weights_expr <- pl$when(valid)$then(weights_expr)$otherwise(-1)$cast(
    pl$UInt32
  )$cast(pl$Int32)

  to_drop <- character(0)
  if (.remove && quo_is_symbol(weights_quo)) {
    weight_name <- as_string(get_expr(weights_quo))
    if (weight_name %in% names(schema)) {
      to_drop <- weight_name
      grps <- setdiff(grps, weight_name)
    }
  }

  # Exploding only the copy indices duplicates all other columns unchanged.
  # Drop before exploding to avoid repeating a column that will be removed.
  out <- with_polars_errors(
    data$with_columns(
      pl$int_ranges(0L, weights_expr, dtype = pl$Int32)$alias(temp)
    )$drop(to_drop)$explode(temp, empty_as_null = FALSE)
  )

  if (!is.null(.id)) {
    out <- out$with_columns((pl$col(temp) + 1L)$alias(.id))
  }

  out <- out$drop(temp)

  # Polars methods drop the grouping attributes. Set them back directly since
  # group_by() would resolve the schema again.
  if (!is_empty(grps)) {
    attr(out, "pl_grps") <- grps
    attr(out, "maintain_grp_order") <- mo
  }

  add_tidypolars_class(out)
}

#' @rdname uncount.polars_data_frame
#' @export
uncount.polars_lazy_frame <- uncount.polars_data_frame
