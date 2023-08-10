#' @import rlang

translate_dots <- function(.data, ...) {
  dots <- enexprs(...)
  lapply(dots, translate_expr, .data = .data)
}

translate_expr <- function(quo, .data) {

  names_data <- pl_colnames(.data)

  if (is_expression(quo)) {
    expr <- quo
    env <- baseenv()
  } else {
    expr <- quo_get_expr(quo)
    env <- quo_get_env(quo)
  }

  used <- character()
  # we want to distinguish literals that are passed as-is and should be put in
  # pl$lit() from those who are passed as a function argument.
  call_is_function <- typeof(expr) == "language"

  translate <- function(expr) {
    if (is_quosure(expr)) {
      # FIXME: What to do with the environment here?
      expr <- quo_get_expr(expr)
    }

    switch(
      typeof(expr),

      "NULL" = return(NULL),

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
          if (!(ref %in% used)) {
            used <<- c(used, ref)
          }
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

        known_functions <- r_polars_funs$r_funs
        known_ops <- c("+", "-", "*", "/", ">", ">=", "<", "<=", "==", "!=",
                       "&", "|", "!")
        user_defined <- get_globenv_functions()
        known <- c(known_functions, known_ops)

        if (!(name %in% known) && !name %in% user_defined) {
          abort(paste0("Unknown function: ", name))
        }

        args <- lapply(as.list(expr[-1]), translate)
        if (name %in% known_functions) {
          name <- paste0("pl_", name)
        }

        fun <- do.call(name, args)
        fun
      },

      abort(paste0("Internal: Unknown type ", typeof(expr)))
    )
  }

  translate(expr)
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
