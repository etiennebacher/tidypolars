#' @import rlang

translate_dots <- function(.data, ...) {
  dots <- enexprs(...)

  new_vars <- lapply(1:length(dots), \(x) character(0))
  new_vars <- setNames(new_vars, paste0("pool_vars_", 1:length(dots)))

  out <- lapply(seq_along(dots), \(x) {
    tmp <- translate_expr(.data = .data, dots[[x]], names(dots)[x], new_vars)
    new_vars[[paste0("pool_vars_", tmp$which_pool_var)]] <<- c(
      new_vars[[paste0("pool_vars_", tmp$which_pool_var)]],
      tmp$new_vars
    )
    tmp$out
  })

  # https://stackoverflow.com/questions/76900694/
  # names(out) <- ""
  # for (i in seq_along(dots)) {
  #   if (is.na(names(out)[i]) && !is.list(out[[i]])) {
  #     names(out)[i] <- names(dots)[i]
  #   }
  # }

  # browser()

  names(out) <- names(dots)
  new_vars <- Filter(\(x) length(x) > 0, new_vars)

  pool_exprs <- lapply(1:length(new_vars), \(x) character(0))
  pool_exprs <- setNames(pool_exprs, paste0("pool_exprs_", 1:length(new_vars)))


  for (i in seq_along(new_vars)) {
    pool_exprs[[i]] <- out[new_vars[[i]]]
    out <- out[-match(new_vars[[i]], names(out))]
  }


  # across() returns a nested list
  # unlist(out, recursive = FALSE, use.names = TRUE)
  pool_exprs
}

translate_expr <- function(.data, quo, new_var, new_vars) {

  names_data <- pl_colnames(.data)

  if (!is_quosure(quo)) {
    quo <- enquo(quo)
  }

  if (is_expression(quo)) {
    expr <- quo
    env <- baseenv()
  } else {
    expr <- quo_get_expr(quo)
    env <- quo_get_env(quo)
  }

  used <- character()
  # we want to distinguish literals that are passed as-is and should be put in
  # pl$lit() (e.g "x = TRUE") from those who are passed as a function argument
  # e.g ("x = mean(y, TRUE)").
  # TODO: drop the exception about paste0(). I had to put it here because
  # pl$concat_str() parses classic characters as column names so I had to make
  # an exception and convert paste0() arguments as polars literals
  call_is_function <- typeof(expr) == "language" && expr[[1]] != "paste0"

  # split across() call early
  if (length(expr) > 1 && safe_deparse(expr[[1]]) == "across") {
    expr <- unpack_across(.data, expr)
  }


  which_pool_var <- 1

  translate <- function(expr) {

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

      "NULL" = {
        which_pool_var <<- find_pool(new_var, new_vars)
        return(NULL)
      },

      character = ,
      logical = ,
      integer = ,
      double = {
        # if call is a function, then the single value is a param, not a literal
        if (call_is_function) {
          return(expr)
        } else {
          which_pool_var <<- find_pool(new_var, new_vars)
          polars_constant(expr)
        }
      },

      symbol = {
        expr_char <- as.character(expr)
        if (expr_char %in% unlist(new_vars)) {
          which_pool_var <<- find_pool(expr_char, new_vars)
          polars_col(expr_char)
        } else if (expr_char %in% names_data) {
          ref <- expr_char
          polars_col(ref)
        } else {
          val <- eval_tidy(expr, env = caller_env(3))
          polars_constant(val)
        }
      },

      language = {
        name <- as.character(expr[[1]])

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
          "c" = {
            subexprs <- as.list(expr)
            subexprs <- subexprs[2:length(subexprs)]
            return(lapply(subexprs, translate))
          },
          ":" = {
            out <- tryCatch(eval_tidy(expr, env = caller_env()), error = identity)
            return(out)
          },
          "%in%" = {
            out <- tryCatch(
              {
                lhs <- translate(expr[[2]])
                rhs <- translate(expr[[3]])
                if (is.list(rhs)) {
                  rhs <- unlist(rhs)
                }
                lhs$is_in(rhs)
              },
              error = identity
            )
            return(out)
          },
          "is.na" = {
            out <- tryCatch(
              {
                inside <- translate(expr[[2]])
                inside$is_null()
              },
              error = identity
            )
            return(out)
          },
          "is.nan" = {
            out <- tryCatch(
              {
                inside <- translate(expr[[2]])
                inside$is_nan()
              },
              error = identity
            )
            return(out)
          }
        )

        k_funs <- get_known_functions()
        known_functions <- k_funs$known_functions
        known_ops <- k_funs$known_ops
        user_defined <- k_funs$user_defined

        if (!(name %in% c(known_functions, known_ops, user_defined))) {
          # last possibility if function is unknown: it's an anonymous function
          # defined in an across() call
          obj_name <- quo_name(expr)
          if (startsWith(obj_name, ".__tidypolars__across_fn")) {
            fn <- eval_bare(global_env()[[obj_name]])
            col_name <- sym(col_name)
            args <- translate(col_name)
            suppressWarnings({
              tr <- try(do.call(fn, list(args)), silent = TRUE)
            })
            if (inherits(tr, "Expr")) {
              return(tr)
            } else {
              abort(
                c("Could not evaluate an anonymous function in `across()`.",
                  "i" = "Are you sure the anonymous function returns a Polars expression?"),
                call = caller_env(7)
              )
            }
          } else {
            abort(paste("Unknown function:", name), call = caller_env(5))
          }
        }

        args <- lapply(as.list(expr[-1]), translate)
        if (name %in% known_functions) {
          name <- r_polars_funs$polars_funs[r_polars_funs$r_funs == name][1]
          name <- paste0("pl_", name)
        }

        fun <- do.call(name, args)
        fun
      },

      abort(
        paste("Internal: Unknown type", typeof(expr)),
        call = caller_env(4)
      )
    )
  }

  # happens because across() calls get split earlier
  if ((is.vector(expr) && length(expr) > 1) || is.list(expr)) {
    out <- lapply(expr, translate)
  } else {
    out <- translate(expr)
  }

  return(list(out = out, new_vars = new_var, which_pool_var = which_pool_var))
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
      paste0("\nWhen the dataset is a Polars DataFrame or LazyFrame, `", fn,
             "`\nonly needs one argument. Additional arguments will not be used."))
  }
}

# TODO: do something with this?
check_polars_expr <- function(exprs, .data) {
  out <- lapply(exprs, \(x) {
    eval_tidy(x, data = .data$to_data_frame())
  })
  not_polars_expr <- which(vapply(out, \(x) !inherits(x, "Expr"), logical(1L)))
  if (length(not_polars_expr) > 0) {
    fault <- exprs[not_polars_expr]
    errors <- lapply(seq_along(fault), \(x) {
      fn_call <- fault[[x]][[2]]
      kf <- known_functions()
      if (safe_deparse(fn_call[[1]]) %in% c(kf$known_functions, kf$kwnow_ops)) {
        return(invisible())
      }
      paste0(names(fault)[x], " = ", safe_deparse(fn_call))
    })
    errors <- Filter(\(x) length(x) > 0, errors)
    if (length(errors) > 0) {
      names(errors) <- rep("*", length(errors))
      abort(
        c(
          paste0("The following call(s) do not return a Polars expression:"),
          errors
        ),
        call = caller_env()
      )
    }
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


find_pool <- function(new_var, new_vars) {
  latest_pool <- Filter(\(x) length(x) > 0, new_vars)
  latest_pool <- length(latest_pool)

  while (latest_pool > 0) {
    if (new_var %in% new_vars[[latest_pool]]) {
      # latest_pool is the pool where the variable we want to use was
      # defined, so we need to store the current expression in the latest
      # pool + 1
      return(latest_pool + 1)
    } else {
      latest_pool <- latest_pool - 1
      if (latest_pool == 0) {
        return(1)
      }
    }
  }
}
