# This file implements a DSL to translate each expression passed in mutate (or
# summarize) to a Polars expression.

# The function `polars_env()` is where we dispatch the rewriting process
# depending on the type of code that is passed. It relies on nested environments,
# the most nested one being the preferred one. There are 3 environments: symbols,
# known functions, and unknown functions.

# `call_env`:
#     - all functions that are unknown
#     - `f_env`:
#           - functions that are in a "whitelist" defined by me. If the called
#             function belongs to `f_env`, it is automatically replaced.
#           - `symbol_env`:
#                 - all symbols that are in a "whitelist". Same as `f_env` but
#                   for symbols.
#
# When we pass the expression, each component passes through `polars_env`.
# First, we check whether it is a symbol e.g Petal.Length (since `symbol_env`
# is the most nested environment, we start by it). If it is one, we check if it's
# a column name.
# If it's not a symbol, then we go to the environment above (`f_env`) where we
# check whether it's a whitelisted function. If so, we prefix it with `pl_`,
# e.g "mean" -> "pl_mean".
# Finally, if it's not a symbol or a known function, it means that it is an
# unknown function, so we pass it through apply() with a warning about efficiency.


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
    names <- NULL
  }
  symbol_env <- as_environment(names, parent = f_env)

  symbol_env
}

# "rec" for "recursive"
all_names_rec <- function(x) {
  switch_expr(
    x,
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
  switch_expr(
    x,
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
