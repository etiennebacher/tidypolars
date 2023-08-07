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


# Takes the original expressions as input, returns a list with 1) the non-NULL
# Polars expressions and 2) the name of the variables to drop.
build_polars_expr <- function(.data, ...) {
  exprs <- rlang::enexprs(...)

  to_drop <- list()
  out <- lapply(seq_along(exprs), function(x) {
    expr <- exprs[[x]]
    res <- rlang::eval_bare(expr, polars_env(expr, .data))

    char_not_colname <- is.character(expr) && !expr %in% pl_colnames(.data)
    other_length_one <- length(x) == 1 && (is.double(expr) || is.logical(expr) || is.integer(expr))
    if (other_length_one || char_not_colname) {
      if (is.character(expr)) {
        res <- paste0("pl$lit('", expr, "')")
      } else {
        res <- paste0("pl$lit(", expr, ")")
      }
    }
    if (is.null(res)) {
      to_drop[[names(exprs)[x]]] <<- 1
      return(NULL)
    }

    paste0("(", res, ")$alias('", names(exprs)[x], "')")
  })

  to_drop <- names(to_drop)
  exprs <- Filter(Negate(is.null), out)
  out <- unlist(out)
  out <- paste(out, collapse = ", ")

  list(exprs = out, to_drop = to_drop)
}

polars_env <- function(expr, .data) {
  # Unknown functions
  calls <- all_calls(expr)
  call_list <- map(set_names(calls), unknown_op)
  call_env <- as_environment(call_list)

  # Known functions
  f_env <- env_clone(f_env, call_env)

  # Default symbols
  names <- all_names(expr)
  new_names <- c()
  for (i in seq_along(names)) {
    if (names[i] %in% pl_colnames(.data)) {
      new_names[i] <- paste0("pl$col('", names[i], "')")
    } else {
      tr <- try(eval(names[i]), silent = TRUE)
      if (!inherits(tr, "try-error")) {
        new_names[i] <- tr
      } else {
        names[i] <- NULL
      }
    }
  }
  if (!is.null(new_names)) {
    new_names <- set_names(new_names, names)
  }
  symbol_env <- as_environment(new_names, parent = f_env)

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
  `>` = binary_op(">"),
  `>=` = binary_op(">="),
  `<` = binary_op("<"),
  `<=` = binary_op("<="),
  `==` = binary_op("=="),
  `!=` = binary_op("!="),
  `&` = binary_op("&"),
  `|` = binary_op("|"),
  `%in%` = function(e1, e2) {
    paste0(e1, "$is_in(pl$lit(", e2, "))")
  },

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
