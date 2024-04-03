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
  attrs <- attributes(x)$polars_expression
  lapply(seq_along(attrs), function(x) {
    e <- deparse(attrs[[x]])
    if (x == 1) {
      gsub("^\\.data\\$", "<data>$\\\n  ", e)
    } else {
      gsub("^\\.data\\$", "$\\\n  ", e)
    }
  }) |>
    unlist() |>
    paste(collapse = "") |>
    cat()
}
