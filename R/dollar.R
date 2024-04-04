#' @export
"$.tidypolars" <- function(x, name) {
  whitelist <- c("shape", "schema", "height", "width", "columns")
  if (name %in% whitelist) {
    NextMethod("$")
  }

  ce <- caller_env()

  class_2 <- class(x)[2]
  my_new_env <- modify_env(
    data = x,
    env_clone(ns_env("polars")[[class_2]]),
    fun_name = name,
    caller_env = ce
  )
  my_new_env[[name]]
}

#' @export
"$.RPolarsExpr" <- function(x, name) {
  my_new_expr_env <- modify_expr_env(
    data = x,
    env_clone(polars:::RPolarsExpr),
    fun_name = name
  )
  my_new_expr_env[[name]]
}
