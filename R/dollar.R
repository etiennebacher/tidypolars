#' @export
"$.tidypolars" <- function(x, name) {

  # Do not overwrite those functions
  whitelist <- c("shape", "schema", "height", "width", "columns", "set_optimization_toggle", "print")
  if (name %in% whitelist) {
    return(NextMethod("$"))
  }

  ce <- caller_env()
  env_to_use <- switch(
    class(x)[2],
    "RPolarsDataFrame" = ns_env("polars")[["RPolarsDataFrame"]],
    "RPolarsLazyFrame" = ns_env("polars")[["RPolarsLazyFrame"]],
    abort("Internal error: don't know what environment to use.")
  )

  fn_to_use <- modify_this_polars_function(env = env_to_use, fun_name = name, data = x, caller_env = ce)
  fn_to_use
}

#' @export
"$.RPolarsExpr" <- function(x, name) {
  expr_to_use <- modify_this_polars_expr(env = polars:::RPolarsExpr, fun_name = name, data = x)
  expr_to_use
}
