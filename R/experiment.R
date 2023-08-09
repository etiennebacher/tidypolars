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
      double = relexpr_constant(expr),

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
          }
        )

        aliases <- c(
          sd = "stddev",
          first = "first_value",
          last = "last_value",
          nth = "nth_value",
          NULL
        )

        known_window <- c(
          # Window functions
          "rank", "rank_dense", "dense_rank", "percent_rank",
          "row_number", "first_value", "last_value", "nth_value",
          "cume_dist", "lead", "lag", "ntile",

          # Aggregates
          "sum", "mean", "stddev", "min", "max",

          NULL
        )

        known_ops <- c("+", "-", "*", "/", ">", ">=", "<", "<=", "==", "!=",
                       "&", "|")

        user_defined <- get_globenv_functions()

        duckplyr_macros <- NULL
        known <- c(names(duckplyr_macros), names(aliases), known_window, known_ops)

        if (!(name %in% known) && !name %in% user_defined) {
          abort(paste0("Unknown function: ", name))
        }

        if (name %in% names(aliases)) {
          name <- aliases[[name]]
        }

        window <- need_window && (name %in% known_window)

        args <- lapply(as.list(expr[-1]), do_translate, in_window = in_window || window)
        if (name %in% known_window) {
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
