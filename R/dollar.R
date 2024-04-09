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
    "RPolarsGroupBy" = ns_env("polars")[["RPolarsGroupBy"]],
    "RPolarsLazyGroupBy" = ns_env("polars")[["RPolarsLazyGroupBy"]],
    abort("Internal error: don't know what environment to use.")
  )

  fn_to_use <- modify_this_polars_function(env = env_to_use, fun_name = name, data = x, caller_env = ce)
  fn_to_use
}

#' @export
"$.tidypolars_expr" <- function(x, name) {
  subns <- c("bin", "cat", "dt", "meta", "str", "struct")
  out <- NULL

  env_to_use <- if (name %in% ls(pl)) {
    pl
  } else if (name == "then") {
    polars:::RPolarsWhen
  } else if (name == "otherwise") {
    polars:::RPolarsThen
  } else if (name %in% ls(polars:::RPolarsExpr)) {
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

  # if (name == "is_in") browser()
  ce <- caller_env()
  expr_to_use <- modify_this_polars_expr(env = env_to_use, fun_name = name, data = x, out = out, caller_env = ce)
  expr_to_use
}

">.tidypolars_expr" <- function(x, name) {
  x$gt(name)
}

">=.tidypolars_expr" <- function(x, name) {
  x$gt_eq(name)
}

"<.tidypolars_expr" <- function(x, name) {
  x$lt(name)
}

"<=.tidypolars_expr" <- function(x, name) {
  x$lt_eq(name)
}

"==.tidypolars_expr" <- function(x, name) {
  x$eq(name)
}

"!=.tidypolars_expr" <- function(x, name) {
  x$neq(name)
}

"+.tidypolars_expr" <- function(x, name) {
  x$add(name)
}

"*.tidypolars_expr" <- function(x, name) {
  x$mul(name)
}

"-.tidypolars_expr" <- function(x, name) {
  x$sub(name)
}

"/.tidypolars_expr" <- function(x, name) {
  x$div(name)
}

"^.tidypolars_expr" <- function(x, name) {
  x$pow(name)
}

"|.tidypolars_expr" <- function(x, name) {
  x$or(name)
}

"&.tidypolars_expr" <- function(x, name) {
  x$and(name)
}

"!.tidypolars_expr" <- function(x, name) {
  x$not(name)
}
