`$.tidypolars` <- function(x, name) {
  whitelist <- c("shape", "schema", "height", "width")
  if (name %in% whitelist) {
    NextMethod("$")
  }
  if (name == "agg") {
    TidyPolarsDataFrame <- modify_env(
      data = x,
      env_clone(polars:::RPolarsGroupBy),
      fun_name = name
    )
  } else {
    TidyPolarsDataFrame <- modify_env(
      data = x,
      env_clone(polars:::RPolarsDataFrame),
      fun_name = name
    )
  }
  TidyPolarsDataFrame[[name]]
}

#' @export
show_query.tidypolars <- function(x) {
  cat("Pure polars expression:\n\n")
  attrs <- attributes(x)$polars_expression
  out <- lapply(seq_along(attrs), function(x) {
    e <- attrs[[x]]
    e <- gsub("^[^\\$]+\\$", "$", e)
    gsub("^\\$", "$\\\n  ", e)
  }) |>
    unlist() |>
    paste(collapse = "")
  out <- paste0("<data>", out)
  cat(out)
}
