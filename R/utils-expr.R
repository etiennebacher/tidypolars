#' @import rlang

translate_dots <- function(.data, ...) {
  dots <- enexprs(...)
  out <- lapply(dots, \(x) {
    translate_expr(.data = .data, x)
  })
  # across() returns a nested list
  unlist(out, recursive = FALSE, use.names = TRUE)
}

translate_expr <- function(.data, quo) {

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
  if (length(expr) > 0 && safe_deparse(expr[[1]]) == "across") {
    expr <- unpack_across(.data, expr)
  }

  translate <- function(expr) {

    if (length(expr) == 1 && all(is.character(expr)) &&
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
        if (call_is_function) {
          return(expr)
        } else {
          polars_constant(expr)
        }
      },

      symbol = {
        if (as.character(expr) %in% names_data) {
          ref <- as.character(expr)
          polars_col(ref)
        } else {
          val <- eval_tidy(expr, env = caller_env())
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
                lhs <- translate(expr[[2]])
                rhs <- translate(expr[[3]])
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

        k_funs <- known_functions()
        known_functions <- k_funs$known_functions
        known_ops <- k_funs$known_ops
        user_defined <- k_funs$user_defined

        known <- c(known_functions, known_ops)

        if (!(name %in% c(known, user_defined))) {
          potential_name <- quo_name(expr)
          if (startsWith(potential_name, ".__tidypolars__across_fn")) {
            fn <- eval_bare(global_env()[[potential_name]])
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
            abort(paste0("Unknown function: ", name))
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

      abort(paste0("Internal: Unknown type ", typeof(expr)))
    )
  }

  # happens because across() calls get split earlier
  if (is.vector(expr) || is.list(expr)) {
    lapply(expr, translate)
  } else {
    translate(expr)
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
    rlang::warn(paste0("\nWhen the dataset is a Polars DataFrame or LazyFrame, `", fn, "` only needs one argument. Additional arguments will not be used."))
  }
}

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


known_functions <- function() {
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
