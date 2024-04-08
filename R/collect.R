#' Collect a LazyFrame
#'
#' @description
#' `compute()` checks the query, optimizes it in the background, and runs it.
#' The output is a [Polars DataFrame][polars::DataFrame_class]. `collect()` is
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
#' @param no_optimization Sets the following optimizations to `FALSE`:
#' `predicate_pushdown`, `projection_pushdown`,  `slice_pushdown`,
#' `simplify_expression`. Default is `FALSE`.
#' @param streaming Run parts of the query in a streaming fashion (this is in
#' an alpha state). Default is `FALSE`.
#' @param collect_in_background Detach this query from the R session. Computation
#' will start in background. Get a handle which later can be converted into the
#' resulting DataFrame. Useful in interactive mode to not lock R session (default
#' is `FALSE`).
#' @param verbose If `TRUE` (default), show the deprecation warning on the
#' usage of `collect()`.
#' @inheritParams slice_tail.RPolarsDataFrame
#'
#' @export
#' @seealso [fetch()] for applying a lazy query on a subset of the data.
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' dat_lazy <- polars::pl$DataFrame(iris)$lazy()
#'
#' compute(dat_lazy)
#'
#' # you can build a query and add compute() as the last piece
#' dat_lazy |>
#'   select(starts_with("Sepal")) |>
#'   filter(between(Sepal.Length, 5, 6)) |>
#'   compute()
compute.RPolarsLazyFrame <- function(
    x,
    type_coercion = TRUE,
    predicate_pushdown = TRUE,
    projection_pushdown = TRUE,
    simplify_expression = TRUE,
    slice_pushdown = TRUE,
    comm_subplan_elim = TRUE,
    comm_subexpr_elim = TRUE,
    no_optimization = FALSE,
    streaming = FALSE,
    collect_in_background = FALSE,
    ...
  ) {
  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order
  is_grouped <- !is.null(grps)

  out <- x$collect(
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    comm_subplan_elim = comm_subplan_elim,
    comm_subexpr_elim = comm_subexpr_elim,
    no_optimization = no_optimization,
    streaming = streaming,
    collect_in_background = collect_in_background
  )

  out <- if (is_grouped) {
    out |>
      group_by(grps, maintain_order = mo)
  } else {
    out
  }

  add_tidypolars_class(out)
}


#' @rdname compute.RPolarsLazyFrame
#' @export
collect.RPolarsLazyFrame <- function(
    x,
    type_coercion = TRUE,
    predicate_pushdown = TRUE,
    projection_pushdown = TRUE,
    simplify_expression = TRUE,
    slice_pushdown = TRUE,
    comm_subplan_elim = TRUE,
    comm_subexpr_elim = TRUE,
    no_optimization = FALSE,
    streaming = FALSE,
    collect_in_background = FALSE,
    verbose = TRUE,
    ...
) {
  if (isTRUE(verbose)) {
    rlang::warn(
      "As of `tidypolars` 0.8.0, `collect()` will automatically convert the Polars DataFrame to a standard R data.frame. Use `compute()` instead (with the same arguments) to have a Polars DataFrame as output.\nUse `verbose = FALSE` to remove this warning."
    )
  }
  x |>
    compute(
      type_coercion = type_coercion,
      predicate_pushdown = predicate_pushdown,
      projection_pushdown = projection_pushdown,
      simplify_expression = simplify_expression,
      slice_pushdown = slice_pushdown,
      comm_subplan_elim = comm_subplan_elim,
      comm_subexpr_elim = comm_subexpr_elim,
      no_optimization = no_optimization,
      streaming = streaming,
      collect_in_background = collect_in_background
    )
}
# collect.RPolarsLazyFrame <- function(
#     x,
#     type_coercion = TRUE,
#     predicate_pushdown = TRUE,
#     projection_pushdown = TRUE,
#     simplify_expression = TRUE,
#     slice_pushdown = TRUE,
#     comm_subplan_elim = TRUE,
#     comm_subexpr_elim = TRUE,
#     no_optimization = FALSE,
#     streaming = FALSE,
#     collect_in_background = FALSE,
#     ...
# ) {
#   x |>
#     as.data.frame(
#       type_coercion = type_coercion,
#       predicate_pushdown = predicate_pushdown,
#       projection_pushdown = projection_pushdown,
#       simplify_expression = simplify_expression,
#       slice_pushdown = slice_pushdown,
#       comm_subplan_elim = comm_subplan_elim,
#       comm_subexpr_elim = comm_subexpr_elim,
#       no_optimization = no_optimization,
#       streaming = streaming,
#       collect_in_background = collect_in_background
#     )
# }
