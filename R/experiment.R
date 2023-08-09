#' @import rlang

rel_translate_dots <- function(dots, data) {
  lapply(dots, rel_translate, data = data)
}

rel_translate <- function(
    quo, data,
    alias = NULL,
    partition = NULL,
    need_window = FALSE
) {

  names_data <- pl_colnames(data)

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

  do_translate <- function(expr, in_window = FALSE) {
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
          relexpr_constant(expr)
        }
      },

      symbol = {
        if (as.character(expr) %in% names_data) {
          ref <- as.character(expr)
          if (!(ref %in% used)) {
            used <<- c(used, ref)
          }
          relexpr_reference(ref)
        } else {
          val <- eval_tidy(expr, env = caller_env())
          relexpr_constant(val)
        }
      },

      language = {
        name <- as.character(expr[[1]])

        switch(
          name,
          "(" = {
            return(do_translate(expr[[2]], in_window = in_window))
          },
          "c" = ,
          ":" = {
            out <- tryCatch(eval_tidy(expr, env = caller_env()), error = identity)
            return(out)
          },
          "%in%" = {
            out <- tryCatch(
              {
                lhs <- do_translate(expr[[2]])
                rhs <- do_translate(expr[[3]])
                lhs$is_in(rhs)
              },
              error = identity
            )
            return(out)
          },
          "is.na" = {
            out <- tryCatch(
              {
                inside <- do_translate(expr[[2]])
                inside$is_null()
              },
              error = identity
            )
            return(out)
          },
          "is.nan" = {
            out <- tryCatch(
              {
                inside <- do_translate(expr[[2]])
                inside$is_nan()
              },
              error = identity
            )
            return(out)
          }
        )

        known_functions <- c(
          # Window functions
          "rank", "rank_dense", "dense_rank", "percent_rank",
          "row_number", "first_value", "last_value", "nth_value",
          "cume_dist", "lead", "lag", "ntile",

          # Aggregates
          "sum", "mean", "stddev", "min", "max", "median",

          "between",

          NULL
        )

        known_ops <- c("+", "-", "*", "/", ">", ">=", "<", "<=", "==", "!=",
                       "&", "|", "!")

        user_defined <- get_globenv_functions()

        known <- c(known_functions, known_ops)

        if (!(name %in% known) && !name %in% user_defined) {
          abort(paste0("Unknown function: ", name))
        }

        args <- lapply(as.list(expr[-1]), do_translate, in_window = in_window || window)
        if (name %in% known_functions) {
          name <- paste0("pl_", name)
        }

        fun <- do.call(name, args)
        fun
      },

      abort(paste0("Internal: Unknown type ", typeof(expr)))
    )
  }

  do_translate(expr)
}

relexpr_constant <- function(x) {
  polars::pl$lit(x)
}

relexpr_reference <- function(x) {
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
