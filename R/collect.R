#' Collect a LazyFrame
#'
#' Polars LazyFrames are not loaded in memory. Running `collect()` checks the
#' execution plan, optimizes it in the background and performs it. The result
#' is loaded in the R session.
#'
#' @param .data A Polars LazyFrame
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
#'
#' @rdname collect
#' @export
#' @seealso [fetch()] for applying a lazy query on a subset of the data.
#' @examples
#' dat_lazy <- polars::pl$DataFrame(iris)$lazy()
#' collect(dat_lazy)
#'
#' # you can build a query and add collect() as the last piece
#' dat_lazy |>
#'   pl_select(starts_with("Sepal")) |>
#'   filter(between(Sepal.Length, 5, 6)) |>
#'   collect()

collect.LazyFrame <- function(
    .data,
    type_coercion = TRUE,
    predicate_pushdown = TRUE,
    projection_pushdown = TRUE,
    simplify_expression = TRUE,
    slice_pushdown = TRUE,
    comm_subplan_elim = TRUE,
    comm_subexpr_elim = TRUE,
    no_optimization = FALSE,
    streaming = FALSE,
    collect_in_background = FALSE
  ) {
  if (!inherits(.data, "LazyFrame")) {
    rlang::abort("`collect()` can only be used on a LazyFrame.")
  }
  .data$collect(
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
