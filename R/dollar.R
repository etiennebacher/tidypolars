`$.tidypolars` <- function(x, name) {
  TidyPolarsDataFrame <- modify_env(
    data = x,
    env_clone(polars:::RPolarsDataFrame)
  )
  TidyPolarsDataFrame[[name]]
}

#' @export
show_query.tidypolars <- function(x) {
  cat("Pure polars expression:\n\n")
  attributes(x)$polars_expression
}
