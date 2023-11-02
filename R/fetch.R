#' Fetch `n` rows of a LazyFrame
#'
#' Fetch is a way to collect only the first `n` rows of a LazyFrame. It is
#' mainly used to test that a query runs as expected on a subset of the data
#' before using `collect()` on the full query. Note that fetching `n` rows
#' doesn't mean that the output will actually contain `n` rows, see the section
#' 'Details' for more information.
#'
#' @param .data A Polars LazyFrame
#' @param n_rows Number of rows to fetch.
#' @inheritParams collect.LazyFrame
#'
#' @details
#' The parameter `n_rows` indicates how many rows from the LazyFrame should be
#' used at the beginning of the query, but it doesn't guarantee that `n_rows` will
#' be returned. For example, if the query contains a filter or join operations
#' with other datasets, then the final number of rows can be lower than `n_rows`.
#' On the other hand, appending some rows during the query can lead to an output
#' that has more rows than `n_rows`.
#'
#' @export
#' @seealso [collect()] for applying a lazy query on the full data.
#' @examples
#' dat_lazy <- polars::pl$DataFrame(iris)$lazy()
#'
#' # this will return 30 rows
#' fetch(dat_lazy, 30)
#'
#' # this will return less than 30 rows because there are less than 30 matches
#' # for this filter in the whole dataset
#' dat_lazy |>
#'   filter(Sepal.Length > 7.0) |>
#'   fetch(30)

fetch <- function(
    .data,
    n_rows = 500,
    type_coercion = TRUE,
    predicate_pushdown = TRUE,
    projection_pushdown = TRUE,
    simplify_expression = TRUE,
    slice_pushdown = TRUE,
    comm_subplan_elim = TRUE,
    comm_subexpr_elim = TRUE,
    no_optimization = FALSE,
    streaming = FALSE
) {
  if (!inherits(.data, "LazyFrame")) {
    rlang::abort("`fetch()` can only be used on a LazyFrame.")
  }
  .data$fetch(
    n_rows = n_rows,
    type_coercion = type_coercion,
    predicate_pushdown = predicate_pushdown,
    projection_pushdown = projection_pushdown,
    simplify_expression = simplify_expression,
    slice_pushdown = slice_pushdown,
    comm_subplan_elim = comm_subplan_elim,
    comm_subexpr_elim = comm_subexpr_elim,
    no_optimization = no_optimization,
    streaming = streaming
  )
}
