#' @import rlang

translate_dots <- function(.data, ..., env) {
  dots <- enexprs(...)
  new_vars <- c()
  out <- lapply(seq_along(dots), \(x) {
    tmp <- translate_expr(.data = .data, dots[[x]], new_vars = new_vars, env = env)
    new_vars <<- c(new_vars, names(dots)[x])
    tmp
  })

  # no need to reorder expressions if they come from filter()
  if (length(unique(names(dots))) == 1 && unique(names(dots)) == "") {
    return(out)
  }

  names(out) <- names(dots)

  # across() returns a nested list
  out <- unlist(out, recursive = FALSE, use.names = TRUE)
  out <- reorder_exprs(out)
  out
}

translate_expr <- function(.data, quo, env, new_vars = NULL) {

  names_data <- pl_colnames(.data)

  if (!is_quosure(quo)) {
    quo <- enquo(quo)
  }

  if (is_expression(quo)) {
    expr <- quo
  } else {
    expr <- quo_get_expr(quo)
  }

  # we want to distinguish literals that are passed as-is and should be put in
  # pl$lit() (e.g "x = TRUE") from those who are passed as a function argument
  # e.g ("x = mean(y, TRUE)").
  # TODO: drop the exception about paste0(). I had to put it here because
  # pl$concat_str() parses classic characters as column names so I had to make
  # an exception and convert paste0() arguments as polars literals
  call_is_function <-
    typeof(expr) == "language" &&
    !safe_deparse(expr[[1]]) %in% c("paste0", "paste")

  # split across() call early
  if (length(expr) > 1 && safe_deparse(expr[[1]]) == "across") {
    expr <- unpack_across(.data, expr)
  }

  translate <- function(expr, new_vars, env) {

    # prepare function and arg if the user provided an anonymous function in
    # across()
    if (length(expr) == 1 && is.character(expr) &&
        startsWith(expr, ".__tidypolars__across_fn")) {
      col_name <- gsub(".__tidypolars__across_fn.*---", "", expr)
      expr <- gsub("---.*", "", expr)
      foo <- sym(expr)
      expr <- enquo(foo)
    }

    switch(
      typeof(expr),

      "NULL" = return(list(NULL)),

      character = ,
      logical = ,
      integer = ,
      double = {
        # if call is a function, then the single value is a param, not a literal
        if (call_is_function) {
          return(expr)
        } else {
          polars_constant(expr)
        }
      },

      symbol = {
        expr_char <- as.character(expr)
        if (expr_char %in% names_data || expr_char %in% unlist(new_vars)) {
          polars_col(expr_char)
        } else {
          val <- eval_tidy(expr, env = env)
          polars_constant(val)
        }
      },

      language = {
        name <- as.character(expr[[1]])
        if (length(name) == 3 && name[[1]] == "::") {
          abort(
            c(
              "tidypolars doesn't work when expressions contain `<pkg>::`.",
              "Use `library(<pkg>)` in your script instead."
            ),
            call = env
          )
        }

        switch(
          name,
          "(" = {
            return(translate(expr[[2]]))
          },
          # these two case_ functions are handled separately from other funs
          # because we don't want to evaluate the conditions inside too soon
          "case_match" =  {
            args <- call_args(expr)
            args$.data <- .data
            return(do.call(pl_case_match, args))
          },
          "case_when" = {
            args <- call_args(expr)
            args$.data <- .data
            return(do.call(pl_case_when, args))
          },
          "c" = ,
          ":" = {
            out <- tryCatch(eval_tidy(expr, env = caller_env()), error = identity)
            return(out)
          },
          "%in%" = {
            out <- tryCatch(
              {
                lhs <- translate(expr[[2]], env = env)
                rhs <- translate(expr[[3]], env = env)
                if (is.list(rhs)) {
                  rhs <- unlist(rhs)
                }
                lhs$is_in(rhs)
              },
              error = identity
            )
            return(out)
          },
          "ifelse" = ,
          "if_else" =  {
            args <- call_args(expr)
            args$.data <- .data
            return(do.call(pl_ifelse, args))
          },
          "is.na" = {
            out <- tryCatch(
              {
                inside <- translate(expr[[2]], env = env)
                inside$is_null()
              },
              error = identity
            )
            return(out)
          },
          "is.nan" = {
            out <- tryCatch(
              {
                inside <- translate(expr[[2]], env = env)
                inside$is_nan()
              },
              error = identity
            )
            return(out)
          },
          "fixed" = {
            out <- expr[[2]]
            attr(out, "stringr_attr") <- "fixed"
            return(out)
          }
        )

        k_funs <- get_known_functions()
        known_functions <- k_funs$known_functions
        known_ops <- k_funs$known_ops
        user_defined <- k_funs$user_defined

        if (!(name %in% c(known_functions, known_ops, user_defined))) {
          # last possibility in function is unknown: it's an anonymous function
          # defined in an across() call
          obj_name <- quo_name(expr)
          if (startsWith(obj_name, ".__tidypolars__across_fn")) {
            fn <- eval_bare(global_env()[[obj_name]])
            col_name <- sym(col_name)
            args <- translate(col_name, env = env)
            suppressWarnings({
              tr <- try(do.call(fn, list(args)), silent = TRUE)
            })
            if (inherits(tr, "Expr")) {
              return(tr)
            } else {
              abort(
                c("Could not evaluate an anonymous function in `across()`.",
                  "i" = "Are you sure the anonymous function returns a Polars expression?"),
                call = env
              )
            }
          } else {
            abort(paste("Unknown function:", name), call = env)
          }
        }

        args <- lapply(as.list(expr[-1]), translate, new_vars = new_vars, env = env)
        if (name %in% known_functions) {
          name <- r_polars_funs$polars_funs[r_polars_funs$r_funs == name][1]
          name <- paste0("pl_", name)
        }

        tryCatch(
          do.call(name, args),
          error = function(e) {
            if (!inherits(e, "tidypolars_error")) {
              orig_name <- gsub("^pl_", "", name)
              abort(
                c(
                  paste0("Couldn't evaluate function `", orig_name, "()` in Polars."),
                  "i" = "Are you sure it returns a Polars expression?"
                ),
                call = env
              )
            } else {
              abort(e$message, call = env)
            }
          }
        )
      },

      abort(
        paste("Internal: Unknown type", typeof(expr)),
        call = env
      )
    )
  }

  # happens because across() calls get split earlier
  if ((is.vector(expr) && length(expr) > 1) || is.list(expr)) {
    lapply(expr, translate, new_vars = new_vars, env = env)
  } else {
    translate(expr, new_vars = new_vars, env = env)
  }
}

polars_constant <- function(x) {
  polars::pl$lit(x)
}

polars_col <- function(x) {
  polars::pl$col(x)
}

# Look for user-defined functions in the global environment
get_globenv_functions <- function() {
  x <- ls(global_env())
  list_fns <- list()
  for (i in x) {
    foo <- get(i, envir = global_env())
    if (is.function(foo)) {
      list_fns[[i]] <- i
    }
  }
  unlist(list_fns)
}

# Used when I convert R functions to polars functions. E.g warn that na.rm = TRUE
# exists in the R function but will not be used in the polars function.
check_empty_dots <- function(...) {
  dots <- get_dots(...)
  if (length(dots) > 0) {
    fn <- deparse(match.call(call = sys.call(sys.parent()))[1])
    fn <- gsub("^pl\\_", "", fn)
    rlang::warn(
      paste0(
        "\nNot all arguments of ", fn, " are used by Polars.\n",
        "The following argument(s) will not be used: ",
        toString(paste0("`", names(dots), "`")),
        "."
      )
    )
  }
}

# Return a list of all functions / operations we know
get_known_functions <- function() {
  known_functions <- r_polars_funs$r_funs
  known_ops <- c("+", "-", "*", "/", ">", ">=", "<", "<=", "==", "!=",
                 "&", "|", "!")
  user_defined <- get_globenv_functions()
  list(
    known_functions = known_functions,
    known_ops = known_ops,
    user_defined = user_defined
  )
}


# this function takes a list of expressions and outputs a nested list. Each
# sublist should be run in one `with_columns()` call.
#
# Polars cannot run two expressions that modify the same column in a single
# with_columns() call, hence the need to split expressions.
#
# For each expression, we store the LHS variable (which is either created or
# modified) in `lhs_vars`. We then get the list of variables that this
# expression uses. If any of the variables it uses is in the pool of created
# (or modified variable) then we store this expression in a new sublist.

reorder_exprs <- function(exprs) {
  lhs_vars <- lapply(seq_along(exprs), \(x) character(0))
  names(lhs_vars) <- paste0("pool_vars_", seq_along(exprs))

  for (i in seq_along(exprs)) {
    if (i == 1) {
      lhs_vars[[1]] <- names(exprs)[i]
      next
    }

    # We can have several pools of variables that correspond to several groups
    # of expressions.
    # We work backwards. Example: suppose we have three expressions:
    # - x = Sepal.Length + 2
    # - Petal.Width = x * 3
    # - ratio = Petal.Width / Petal.Length
    #
    # The LHS variable in the first expression necessarily goes in the first
    # pool of variables. When we reach the second expression, we see that it
    # uses "x", which is in the first pool of variables, so we can't store
    # "Petal.Width" here too, so it goes in the second pool of variables.
    #
    # When we reach the third expression, we have two pools:
    # - pool 1 contains "x"
    # - pool 2 contains "Petal.Width"
    #
    # Since "ratio" uses "Petal.Width", it cannot go there, so it is put in a
    # third pool. In the end, we have three pools of variables and therefore
    # three calls to `with_columns()`.
    #
    # However, suppose the last expression was: ratio = x + Sepal.Width
    #
    # This expression doesn't use any var in the second pool, so we check whether
    # it uses any var in the first pool. It does (it uses "x"), so we store it
    # in the second pool. Therefore, we will end up with two calls to
    # `with_columns()`.

    latest_pool <- length(compact(lhs_vars))

    if (is.null(exprs[[i]])) {
      vars_used <- character(0)
    } else {
      vars_used <- exprs[[i]]$meta$root_names()
    }
    new_var <- names(exprs)[i]

    while (latest_pool > 0) {
      if (any(c(vars_used, new_var) %in% lhs_vars[[latest_pool]])) {
        # latest_pool is the pool where the variable we want to use was
        # defined, so we need to store the current expression in the latest
        # pool + 1
        lhs_vars[[latest_pool + 1]] <- c(lhs_vars[[latest_pool + 1]], new_var)
        break
      } else {
        latest_pool <- latest_pool - 1
        if (latest_pool == 0) {
          lhs_vars[[1]] <- c(lhs_vars[[1]], new_var)
        }
      }
    }
  }
  lhs_vars <- compact(lhs_vars)
  pool_exprs <- lapply(seq_along(lhs_vars), \(x) character(0))
  names(pool_exprs) <- paste0("pool_exprs_", seq_along(lhs_vars))

  for (i in seq_along(lhs_vars)) {
    pool_exprs[[i]] <- exprs[lhs_vars[[i]]]
    exprs <- exprs[-match(lhs_vars[[i]], names(exprs))]
  }

  pool_exprs
}
