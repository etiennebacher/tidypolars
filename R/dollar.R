#' @export
"$.tidypolars" <- function(x, name) {

  # Do not overwrite those functions
  whitelist <- c("shape", "schema", "height", "width", "columns",
                 "set_optimization_toggle", "print", "clone", "to_list",
                 "to_data_frame")
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

  fn_to_use <- modify_this_polars_function(
    env = env_to_use,
    env_name = class(x)[2],
    fun_name = name,
    data = x,
    caller_env = ce
  )
  fn_to_use
}

#' @export
"$.tidypolars_expr" <- function(x, name) {
  out <- NULL

  # Some methods are in "pl" and in "Expr", e.g implode(). "pl" is an environment
  # while "Expr" is a simple class
  env_to_use <- if (is.environment(x) && name %in% ls(pl)) {
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

  ce <- caller_env()
  expr_to_use <- modify_this_polars_expr(
    env = env_to_use,
    env_name = class(x)[2],
    fun_name = name,
    data = x,
    out = out,
    caller_env = ce
  )
  expr_to_use
}

">.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$gt(name)
  } else {
    my_wrap_e(x)$gt(name)
  }
}

">=.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$gt_eq(name)
  } else {
    my_wrap_e(x)$gt_eq(name)
  }
}

"<.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$lt(name)
  } else {
    my_wrap_e(x)$lt(name)
  }
}

"<=.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$lt_eq(name)
  } else {
    my_wrap_e(x)$lt_eq(name)
  }
}

"==.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$eq(name)
  } else {
    my_wrap_e(x)$eq(name)
  }
}

"!=.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$neq(name)
  } else {
    my_wrap_e(x)$neq(name)
  }
}

"+.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$add(name)
  } else {
    my_wrap_e(x)$add(name)
  }
}

"*.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$mul(name)
  } else {
    my_wrap_e(x)$mul(name)
  }
}

"-.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$sub(name)
  } else {
    my_wrap_e(x)$sub(name)
  }
}

"/.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$div(name)
  } else {
    my_wrap_e(x)$div(name)
  }
}

"^.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$pow(name)
  } else {
    my_wrap_e(x)$pow(name)
  }
}

"|.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$or(name)
  } else {
    my_wrap_e(x)$or(name)
  }
}

"&.tidypolars_expr" <- function(x, name) {
  if (inherits(x, "RPolarsExpr")) {
    x$and(name)
  } else {
    my_wrap_e(x)$and(name)
  }
}

"!.tidypolars_expr" <- function(x) {
  if (inherits(x, "RPolarsExpr")) {
    x$not()
  } else {
    NextMethod("!")
  }
}
