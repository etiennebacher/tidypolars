
polars_env <- function(expr, .data) {

  # Unknown functions
  calls <- all_calls(expr)
  call_list <- map(set_names(calls), unknown_op)
  call_env <- as_environment(call_list)

  # Known functions
  f_env <- env_clone(f_env, call_env)

  # Default symbols
  names <- all_names(expr)
  if (length(names) == 1 && names %in% pl_colnames(.data)) {
    names <- set_names(paste0("pl$col('", names, "')"), names)
  } else {
    names <- set_names(names)
  }
  symbol_env <- as_environment(names, parent = f_env)

  symbol_env
}

all_names_rec <- function(x) {
  switch_expr(x,
              constant = character(),
              symbol =   as.character(x),
              call =     flat_map_chr(as.list(x[-1]), all_names)
  )
}

all_names <- function(x) {
  unique(all_names_rec(x))
}

unary_op <- function(left) {
  new_function(
    exprs(e1 = ),
    expr(
      paste0("pl_", !!left, "(", e1, ")")
    ),
    caller_env()
  )
}

binary_op <- function(sep) {
  new_function(
    exprs(e1 = , e2 = ),
    expr(
      paste0(e1, !!sep, e2)
    ),
    caller_env()
  )
}

# Binary operators
f_env <- child_env(
  .parent = empty_env(),
  `+` = binary_op(" + "),
  `-` = binary_op(" - "),
  `*` = binary_op(" * "),
  `/` = binary_op(" / "),
  `^` = binary_op("^"),

  mean = unary_op("mean")
)

unknown_op <- function(op) {
  new_function(
    exprs(... = ),
    expr({
      contents <- paste(..., collapse = ", ")
      paste0(!!paste0("pl_apply(", op, ")"), contents, ")")
    })
  )
}

all_calls_rec <- function(x) {
  switch_expr(x,
              constant = ,
              symbol =   character(),
              call = {
                fname <- as.character(x[[1]])
                children <- flat_map_chr(as.list(x[-1]), all_calls)
                c(fname, children)
              }
  )
}
all_calls <- function(x) {
  unique(all_calls_rec(x))
}
