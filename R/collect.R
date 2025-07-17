#' Collect a LazyFrame
#'
#' @description
#' `compute()` checks the query, optimizes it in the background, and runs it.
#' The output is a [Polars DataFrame][polars::pl__DataFrame]. `collect()` is
#' similar to `compute()` but converts the output to an R [data.frame], which
#' consumes more memory.
#'
#' Until `tidypolars` 0.7.0, there was only `collect()` and it was used to
#' collect a LazyFrame into a Polars DataFrame. This usage is still valid for
#' now but will change in 0.8.0 to automatically convert a DataFrame to a
#' `data.frame`. Use `compute()` to have a Polars DataFrame as output.
#'
#' @param x A Polars LazyFrame
#' @param type_coercion Coerce types such that operations succeed and run on
#' minimal required memory (default is `TRUE`).
#' @param predicate_pushdown Applies filters as early as possible at scan level
#' (default is `TRUE`).
#' @param projection_pushdown Select only the columns that are needed at the scan
#' level (default is `TRUE`).
#' @param simplify_expression Various optimizations, such as constant folding
#' and replacing expensive operations with faster alternatives (default is
#' `TRUE`).
#' @param slice_pushdown Only load the required slice from the scan. Don't
#' materialize sliced outputs level. Don't materialize sliced outputs (default
#' is `TRUE`).
#' @param comm_subplan_elim Cache branching subplans that occur on self-joins or
#' unions (default is `TRUE`).
#' @param comm_subexpr_elim Cache common subexpressions (default is `TRUE`).
#' @param cluster_with_columns Combine sequential independent calls to
#' `$with_columns()`.
#' @param no_optimization Sets the following optimizations to `FALSE`:
#' `predicate_pushdown`, `projection_pushdown`,  `slice_pushdown`,
#' `simplify_expression`. Default is `FALSE`.
#' @param engine The engine name to use for processing the query. One of the
#' followings:
#' - `"auto"` (default): Select the engine automatically. The `"in-memory"`
#'   engine will be selected for most cases.
#' - `"in-memory"`: Use the in-memory engine.
#' - `"streaming"`: Use the streaming engine, usually faster and can handle
#'   larger-than-memory data.
#' @inheritParams slice_tail.polars_data_frame
#' @param streaming `r lifecycle::badge("deprecated")` Deprecated, use `engine`
#' instead.
#'
#' @param .name_repair,uint8,int64,date,time,decimal,as_clock_class,ambiguous,non_existent Parameters to control the conversion from polars types to R. See
#' `?polars:::as.data.frame.polars_lazy_frame` for explanations and accepted
#' values.
#'
#' @export
#' @seealso [fetch()] for applying a lazy query on a subset of the data.
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' dat_lazy <- polars::as_polars_df(iris)$lazy()
#'
#' compute(dat_lazy)
#'
#' # you can build a query and add compute() as the last piece
#' dat_lazy |>
#'   select(starts_with("Sepal")) |>
#'   filter(between(Sepal.Length, 5, 6)) |>
#'   compute()
#'
#' # call collect() instead to return a data.frame (note that this is more
#' # expensive than compute())
#' dat_lazy |>
#'   select(starts_with("Sepal")) |>
#'   filter(between(Sepal.Length, 5, 6)) |>
#'   collect()
compute.polars_lazy_frame <- function(
  x,
  ...,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  comm_subplan_elim = TRUE,
  comm_subexpr_elim = TRUE,
  cluster_with_columns = TRUE,
  no_optimization = FALSE,
  engine = c("auto", "in-memory", "streaming"),
  streaming = FALSE
) {
  check_dots_empty()
  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order
  is_grouped <- !is.null(grps)

  if (!missing(streaming)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "compute(streaming)",
      details = c(
        i = "Use `engine = \"streaming\"` for the new streaming mode.",
        i = "Use `engine = \"in-memory\"` for non-streaming mode."
      ),
    )
    if (isTRUE(streaming)) {
      engine <- "streaming"
    }
    if (isFALSE(streaming)) engine <- "in-memory"
  }

  out <- x$collect(
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    comm_subplan_elim = comm_subplan_elim,
    comm_subexpr_elim = comm_subexpr_elim,
    cluster_with_columns = cluster_with_columns,
    no_optimization = no_optimization,
    engine = engine
  )

  out <- if (is_grouped) {
    out |>
      group_by(all_of(grps), maintain_order = mo)
  } else {
    out
  }

  add_tidypolars_class(out)
}

#' @rdname compute.polars_lazy_frame
#' @export
collect.polars_lazy_frame <- function(
  x,
  ...,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  comm_subplan_elim = TRUE,
  comm_subexpr_elim = TRUE,
  cluster_with_columns = TRUE,
  no_optimization = FALSE,
  engine = c("auto", "in-memory", "streaming"),
  streaming = FALSE,
  .name_repair = "check_unique",
  uint8 = "integer",
  int64 = "double",
  date = "Date",
  time = "hms",
  decimal = "double",
  as_clock_class = FALSE,
  ambiguous = "raise",
  non_existent = "raise"
) {
  check_dots_empty()

  if (!missing(streaming)) {
    lifecycle::deprecate_warn(
      when = "0.14.0",
      what = "collect(streaming)",
      details = c(
        i = "Use `engine = \"streaming\"` for the new streaming mode.",
        i = "Use `engine = \"in-memory\"` for non-streaming mode."
      ),
    )
    if (isTRUE(streaming)) {
      engine <- "streaming"
    }
    if (isFALSE(streaming)) engine <- "in-memory"
  }

  x |>
    as.data.frame(
      type_coercion = type_coercion,
      predicate_pushdown = predicate_pushdown,
      projection_pushdown = projection_pushdown,
      simplify_expression = simplify_expression,
      slice_pushdown = slice_pushdown,
      comm_subplan_elim = comm_subplan_elim,
      comm_subexpr_elim = comm_subexpr_elim,
      cluster_with_columns = cluster_with_columns,
      no_optimization = no_optimization,
      engine = engine,
      .name_repair = .name_repair,
      uint8 = uint8,
      int64 = int64,
      date = date,
      time = time,
      decimal = decimal,
      as_clock_class = as_clock_class,
      ambiguous = ambiguous,
      non_existent = non_existent
    )
}
