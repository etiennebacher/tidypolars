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
"$.tidypolars_expr" <- function(x, name) {
  subns <- c("bin", "cat", "dt", "meta", "str", "struct")
  # accepted_methods <- setdiff(ls(polars:::RPolarsExpr), subns)
  accepted_methods <- ls(polars:::RPolarsExpr)
  out <- NULL



  # if (name == "root_names") browser()

  env_to_use <- if (name %in% ls(pl)) {
    pl
  } else if (name %in% accepted_methods) {
    polars:::RPolarsExpr
  }

  if (is.environment(x)) {
    env_to_use <- x
    x <- attributes(x)$self
  }

  # else if (name %in% subns) {
  #   env_to_use <- NextMethod("$")
  #   out <- NextMethod("$")
  # }

  expr_to_use <- modify_this_polars_expr(env = env_to_use, fun_name = name, data = x, out = out)
  expr_to_use
}
