# inspired from dplyr/across.R
# [MIT license]

unpack_across <- function(.data, expr, env, new_vars) {
  .cols <- get_arg(".cols", 1, expr, env)

  # Need this trick to correctly evaluate .cols = where(is.numeric)
  .cols_with_env <- enquo(.cols)
  attr(.cols_with_env, ".Environment") <- env
  .cols_already_there <- tidyselect_named_arg(.data, .cols_with_env)

  .cols_new_vars <- tidyselect_new_vars(.cols, new_vars)
  .cols <- union(.cols_already_there, .cols_new_vars)
  .fns <- get_arg(".fns", 2, expr, env)
  if (is.name(.fns)) {
    .fns <- unpack_fns(.fns, env)
  }
  .names <- get_arg(".names", 3, expr, env)

  harmonize <- function(x) {
    if (is_formula(x)) { # e.g ~ mean(.x) -> mean(.x)
      x[[2]]
    } else if (is_symbol(x)) { # e.g mean -> mean(.x)
      out <- call2(x)
      call_modify(out, quote(.x))
    } else {
      # if the user gives an anonymous function, we assign it in the global env
      # with a specific prefix to find it in translate()
      # Note that the function is in the global env but can only be obtained
      # with the correct name (i.e ls(global_env()) doesn't show it).
      nm <- paste0(".__tidypolars__across_fn_", paste(sample(letters, 10), collapse = ""))
      env_bind(.env = global_env(), !!nm := x)
      nm
    }
  }

  if (is.list(.fns)) {
    .new_fns <- Map(function(x) harmonize(x), .fns)
  } else {
    .new_fns <- list(harmonize(.fns))
    if (is_symbol(.fns)) {
      names(.new_fns) <- safe_deparse(.fns)
    }
  }

  out <- build_separate_calls(.cols, .new_fns, .names, .data)
  if (!is.list(out) && length(out) == 1) {
    out <- as.list(out)
  }
  out
}


build_separate_calls <- function(.cols, .fns, .names, .data) {
  list_calls <- list()
  has_names <- !is.null(.names) && length(.names) == 1

  for (i in seq_along(.cols)) {
    for (j in seq_along(.fns)) {

      if (has_names) {
        nm <- gsub("{\\.col}", .cols[i], .names, perl = TRUE)
        if (is.null(names(.fns)[j])) {
          nm <- gsub("{\\.fn}", j, nm, perl = TRUE)
        } else {
          nm <- gsub("{\\.fn}", names(.fns)[j], nm, perl = TRUE)
        }
      } else {
        nm <- .cols[i]
        if (length(.fns) > 1) {
          if (!is.null(names(.fns)[j]) && names(.fns)[j] != "") {
            nm <- paste0(nm, "_", names(.fns)[j])
          } else {
            nm <- paste0(nm, "_", j)
          }
        }
      }

      # if anonymous function, we return the name starting with ".__tidypolars__"
      # so that we can get the function back in translate()
      if (is.character(.fns[[j]])) {
        list_calls[[nm]] <- paste0(.fns[[j]], "---", .cols[i])
        next
      }

      arg <- sym(.cols[i])
      list_calls[[nm]] <- expr_substitute(.fns[[j]], quote(.x), arg)
    }
  }
  unlist(list_calls)
}

# extract arg from across(), either from name or position
get_arg <- function(name, position, expr, env) {
  out <- if (name %in% names(expr)) {
    expr[[name]]
  } else if (length(expr) > 2 && position + 1 <= length(expr)) {
    expr[[position + 1]]
  }

  if (is.null(out) && name == ".cols") {
    rlang::abort(
      "You must supply the argument `.cols` in `across()`.",
      call = env
    )
  }
  # drop the list() call if the user provided a list of functions
  if (name == ".fns" && length(out) > 1 && safe_deparse(out[[1]]) == "list") {
    out[[1]] <- NULL
  }
  out
}

unpack_fns <- function(fns, env) {
  tr <- tryCatch(
    rlang::eval_tidy(fns, env = env),
    error = function(e) return(fns)
  )
  if (!is.list(tr)) {
    return(fns)
  }

  all_fun_or_formula <- all(vapply(
    tr,
    function(x) length(x) > 0 && (is_formula(x) || is_function(x)),
    FUN.VALUE = logical(1L)
  ))

  if (all_fun_or_formula) {
    abort(
      c(
       "When using `across()` in tidypolars, `.fns` doesn't accept an \nobject that is a list of functions or formulas.",
        "i" = "Instead of `across(.fns = <external_list>)`, do \n`across(.fns = list(fun1 = ..., fun2 = ...))`"
      ),
      call = env
    )
  }

  tr
}



# Taken from: https://github.com/tidyverse/dplyr/blob/main/R/utils.R
# [MIT License]

expr_substitute <- function(expr, old, new) {
  expr <- duplicate(expr)
  switch(typeof(expr),
         language = node_walk_replace(node_cdr(expr), old, new),
         symbol = if (identical(expr, old)) return(new)
  )
  expr
}

node_walk_replace <- function(node, old, new) {
  while (!is_null(node)) {
    switch(
      typeof(node_car(node)),
      language = if (!is_call(node_car(node), c("~", "function")) ||
                     is_call(node_car(node), "~", n = 2)) {
        node_walk_replace(node_cdar(node), old, new)
      },
      symbol = if (identical(node_car(node), old)) node_poke_car(node, new)
    )
    node <- node_cdr(node)
  }
}
