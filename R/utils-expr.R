#' Translate all expressions in `...`
#'
#' This is the first out of 3 steps. Here, we convert each expression passed in
#' `...` to a quosure. Then we convert each of those expressions to the polars
#' syntax using `translate_expr()`.
#'
#' Importantly, we keep the name of newly created variables so that they can
#' be used in subsequent expressions in the same call of `mutate()` (or `filter()`,
#' etc.).
#'
#' Finally, we reorder the expressions and create "pools of expressions". Polars
#' cannot create a new variable `foo` and use it in another expression in the
#' same `$with_columns()`. In `reorder_exprs()`, we split expressions to different
#' sublists if they depend on newly created variables, so that we know how many
#' `$with_columns()` calls we need to make in `mutate()`.
#'
#' @param .data The dataset
#' @param ... The `...` containing all expressions by the user.
#' @param env Environment of the function from which this expression is called
#' (`filter()`, `mutate()` or `summarize()`).
#' @param caller User environment in which the function is called.
#'
#' @noRd
#'
#' @return A list of polars expressions. If some expressions depend on newly
#' created variables, then the list will contains sublists, one per `$with_columns()`
#' call to make.

translate_dots <- function(.data, ..., env, caller) {
  dots <- enquos(...)
  if (length(dots) == 0) {
    return()
  }
  dots <- lapply(dots, quo_squash)
  new_vars <- c()
  called_from_arrange <- attr(.data, "called_from_arrange") %||% FALSE

  out <- lapply(seq_along(dots), \(x) {
    expr <- dots[[x]]

    # arrange() is a special case since using "-" on a character column is
    # accepted but invalid for Polars so we need to replace "-" by "desc()"
    # before translating.
    if (isTRUE(called_from_arrange) && length(expr) == 2 && expr[[1]] == "-") {
      expr <- call2("desc", expr[[2]])
    }

    tmp <- translate_expr(
      .data = .data,
      expr,
      new_vars = new_vars,
      env = env,
      caller = caller
    )
    # flir-ignore
    new_vars <<- c(new_vars, names(dots)[x])
    tmp
  })

  # no need to reorder expressions if they come from filter()
  if (length(unique(names(dots))) == 1 && unique(names(dots)) == "") {
    return(out)
  }

  names(out) <- names(dots)

  # across() returns a nested list
  out <- lapply(out, function(x) {
    if (is.list(x)) {
      x
    } else {
      list(x)
    }
  })
  out <- unlist(out, recursive = FALSE, use.names = TRUE)
  out <- reorder_exprs(out)
  out
}

#' Translate an expression
#'
#' This is the second step. It:
#' - transforms expressions to an `rlang::expr`,
#' - detects whether the call is a function or a scalar that can be translated
#'   to a polars literal
#' - unpacks the `across()` call to several separate expressions
#'
#' Then it calls `translate()` to translate each component to the polars syntax.
#'
#' @param .data The data from which it comes from. Useful to get the variable
#' names for instance.
#' @param quo Single quosure.
#' @param new_vars Variables created in previous expressions. Required because
#' if variable "foo" is created in previous expressions, then it becomes available
#' for the current expression.
#' @param env Environment of the function from which this expression is called
#' (`filter()`, `mutate()` or `summarize()`).
#' @param caller User environment in which the function is called.
#' @param expr_uses_col An environment that contains an id corresponding to the
#' expression being translated. This is used to determine whether an expression
#' (that can be part of a larger expression) uses a column from the data or
#' not. If it doesn't, then we can evaluate this expression in the caller
#' environment and not in the data context, meaning that it doesn't require
#' the functions to be translated.
#'
#' Example:
#' ```
#' df <- pl$DataFrame(x = 1:3)
#' a <- 4:6
#' mutate(df, x = my_fun(a))
#' ```
#'
#' `my_fun()` is not translated to polars, but we also see that `my_fun(a)`
#' doesn't use any columns from the data, so it can be evaluated in the calling
#' env and we can use the result after wrapping it in `pl$lit()`.
#'
#' If we changed the code to:
#' ```
#' mutate(df, a = 1, x = my_fun(a))
#' ```
#' then `my_fun(a)` would now use a column and this would error with
#' "tidypolars doesn't how to translate `my_fun()`".
#'
#' @return A full polars expression
#' @noRd

translate_expr <- function(
  .data,
  quo,
  new_vars = NULL,
  env,
  caller = rlang::caller_env(2),
  expr_uses_col = NULL
) {
  # Setting this and then grabbing the attribute when needed is much more
  # efficient than calling names() when there are lots of expressions to
  # evaluate.
  attr(.data, "colnames") <- c(names(.data), new_vars)

  if (is.null(expr_uses_col)) {
    expr_uses_col <- new.env()
    assign("id", FALSE, envir = expr_uses_col)
    assign("counter", 0, envir = expr_uses_col)
  }

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
  call_is_function <- typeof(expr) == "language"

  # split across() call early
  if (length(expr) > 1 && safe_deparse(expr[[1]]) == "across") {
    expr <- unpack_across(
      .data,
      expr,
      env = env,
      caller = caller,
      new_vars = new_vars
    )
  }

  # happens because across() calls get split earlier
  if ((is.vector(expr) && length(expr) > 1) || is.list(expr)) {
    lapply(
      expr,
      translate,
      .data = .data,
      new_vars = new_vars,
      env = env,
      caller = caller,
      call_is_function = call_is_function,
      expr_uses_col = expr_uses_col
    )
  } else {
    translate(
      expr,
      .data = .data,
      new_vars = new_vars,
      env = env,
      caller = caller,
      call_is_function = call_is_function,
      expr_uses_col = expr_uses_col
    )
  }
}

#' Recursively translate components of an expression
#'
#' This is the third step. This function takes an expression (or part of an
#' expression) and decomposes it until there's nothing left to translate. For
#' example `a %in% 1:3` would first call the translation for `%in%`, which itself
#' calls the translation for `a` and `1:3` separately, so that we end up with
#' `pl$col("a")$is_in(pl$lit(1:3))`.
#'
#' @param expr The expression to decompose
#' @param .data The data from which it comes from. Useful to get the variable
#' names for instance.
#' @param new_vars Variables created in previous expressions. Required because
#' if variable "foo" is created in previous expressions, then it becomes
#' available for the current expression.
#' @param env Environment of the function from which this expression is called
#' (`filter()`, `mutate()` or `summarize()`).
#' @param caller User environment in which the function is called.
#' @param call_is_function Is the call a function? Needed to handle separately
#' literals and argument values.
#'
#' @return A single component translated to polars syntax
#' @noRd

translate <- function(
  expr,
  .data,
  new_vars,
  env,
  caller = NULL,
  call_is_function = NULL,
  expr_uses_col
) {
  names_data <- attr(.data, "colnames")

  # prepare function and arg if the user provided an anonymous function in
  # across()
  if (
    length(expr) == 1 &&
      is.character(expr) &&
      startsWith(expr, ".__tidypolars__across_fn")
  ) {
    col_name <- gsub(".__tidypolars__across_fn.*---", "", expr)
    expr <- gsub("---.*", "", expr)
    foo <- sym(expr)
    expr <- enquo(foo)
  }

  # Passing `expr_uses_col` is not enough because even if the top expression
  # uses a col, subexpressions don't necessarily.
  #
  # Example:
  # ```
  # dat <- pl$DataFrame(foo = 1:3)
  # a <- c("d", "e", "f")
  # dat |> filter(foo >= agrep("a", a))
  # ```
  #
  # `foo >= agrep("a", a)` uses the column `foo` but `agrep("a", a)` doesn't
  # use any column so we could evaluate it in the calling env.
  #
  # => we want to update the environment by adding an extra id and use this
  #    latest id when checking whether a (sub)expression contains a column or
  #    not.
  assign(
    "counter",
    expr_uses_col[["counter"]] + 1,
    envir = expr_uses_col
  )
  latest_expr_id <- paste0("id", expr_uses_col[["counter"]])
  assign(latest_expr_id, FALSE, envir = expr_uses_col)

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
        pl$lit(expr)
      }
    },
    symbol = {
      expr_char <- as.character(expr)
      if (expr_char %in% names_data || expr_char %in% unlist(new_vars)) {
        assign(latest_expr_id, TRUE, envir = expr_uses_col)
        pl$col(expr_char)
      } else {
        val <- eval_tidy(expr, env = caller)
        pl$lit(val)
      }
    },
    language = {
      expr2 <- if (is_quosure(expr)) {
        quo_get_expr(expr)
      } else {
        expr[[1]]
      }
      name <- as.character(expr2)
      if (length(name) == 3 && name[[1]] == "::") {
        name <- paste0(name[[2]], "::", name[[3]])
      }

      # e.g. `.tp$str_extract_stringr()`.
      if (length(name) == 3 && name[[1]] == "$" && name[[2]] == ".tp") {
        name <- paste0("pl_", name[[3]])
        args <- call_args(expr)
        args <- lapply(
          args,
          translate,
          .data = .data,
          new_vars = new_vars,
          env = env,
          caller = caller,
          call_is_function = call_is_function,
          expr_uses_col = expr_uses_col
        )
        args[["__tidypolars__new_vars"]] <- as.list(new_vars)
        args[["__tidypolars__env"]] <- env
        args[["__tidypolars__caller"]] <- caller
        args[["__tidypolars__expr_uses_col"]] <- expr_uses_col
        return(do.call(name, args))
      }

      switch(
        name,
        "[" = {
          out <- tryCatch(
            eval_tidy(expr, env = caller),
            error = function(e) {
              cli_abort(e$message, call = env)
            }
          )
          out <- translate(
            out,
            .data = .data,
            new_vars = new_vars,
            env = env,
            caller = caller,
            call_is_function = call_is_function,
            expr_uses_col = expr_uses_col
          )
          return(out)
        },
        # .data$ -> consider the RHS of $ as a classic column name
        # .env$ -> eval the RHS of $ in the caller env
        # <other>$ -> same as .env$ but we don't refer to a lonely object in the
        #             environment but to a data.frame/list subset so we evaluate
        #             the LHS + RHS
        #
        # Same thing with [[ but I pass the expressions in sym()
        "[[" = {
          first_term <- expr[[2]]
          if (first_term == ".data") {
            assign(latest_expr_id, TRUE, envir = expr_uses_col)
            out <- pl$col(expr[[3]])
          } else if (first_term == ".env") {
            out <- tryCatch(
              eval_tidy(sym(expr[[3]]), env = caller),
              error = function(e) {
                cli_abort(e$message, call = env)
              }
            )
          } else {
            out <- tryCatch(
              eval_tidy(expr, env = caller),
              error = function(e) {
                cli_abort(e$message, call = env)
              }
            )
            out <- translate(
              out,
              .data = .data,
              new_vars = new_vars,
              env = env,
              caller = caller,
              call_is_function = call_is_function,
              expr_uses_col = expr_uses_col
            )
          }
          return(out)
        },
        "$" = {
          first_term <- expr[[2]]

          if (is.name(first_term)) {
            first_term <- safe_deparse(first_term)
          }

          if (first_term == ".data") {
            assign(latest_expr_id, TRUE, envir = expr_uses_col)
            dep <- rlang::as_string(expr[[3]])
            out <- pl$col(dep)
          } else if (first_term == ".env") {
            out <- tryCatch(
              eval_tidy(expr[[3]], env = caller),
              error = function(e) {
                cli_abort(e$message, call = env)
              }
            )
          } else {
            out <- tryCatch(
              eval_tidy(expr, env = caller),
              error = function(e) {
                cli_abort(e$message, call = env)
              }
            )
            out <- translate(
              out,
              .data = .data,
              new_vars = new_vars,
              env = env,
              caller = caller,
              call_is_function = call_is_function,
              expr_uses_col = expr_uses_col
            )
          }
          return(out)
        },
        "(" = {
          return(
            translate(
              expr[[2]],
              .data = .data,
              new_vars = new_vars,
              env = env,
              caller = caller,
              call_is_function = call_is_function,
              expr_uses_col = expr_uses_col
            )
          )
        },
        "~" = {
          args <- list(expr[[2]], expr[[3]])
          args <- lapply(
            args,
            translate,
            .data = .data,
            new_vars = new_vars,
            env = env,
            caller = caller,
            call_is_function = call_is_function,
            expr_uses_col = expr_uses_col
          )
          return(args)
        },
        "c" = {
          expr[[1]] <- NULL
          if (
            # we may pass a named vector in str_replace_all() for instance
            !is.null(names(expr)) ||
              # we may pass a vector of column names
              any(vapply(expr, is.symbol, FUN.VALUE = logical(1L)))
          ) {
            return(
              lapply(
                expr,
                translate,
                .data = .data,
                new_vars = new_vars,
                env = env,
                caller = caller,
                call_is_function = call_is_function,
                expr_uses_col = expr_uses_col
              )
            )
          }

          # When we pass e.g mean(c(-1, 0, 1)), the "-1" is of type "language"
          # and therefore we can unlist() the whole thing. Need to evaluate it
          # before that.
          if (any(vapply(expr, is.language, FUN.VALUE = logical(1L)))) {
            expr <- lapply(expr, \(x) {
              if (deparse(x[[1]]) == "-") {
                eval(x)
              } else {
                x
              }
            })
          }

          return(pl$lit(unlist(expr)))
        },
        ":" = {
          out <- tryCatch(eval_tidy(expr, env = caller_env()), error = identity)
          return(out)
        },
        "%in%" = {
          out <- tryCatch(
            {
              lhs <- translate(
                expr[[2]],
                .data = .data,
                new_vars = new_vars,
                env = env,
                caller = caller,
                call_is_function = call_is_function,
                expr_uses_col = expr_uses_col
              ) |>
                as_polars_expr(as_lit = TRUE)
              rhs <- translate(
                expr[[3]],
                .data = .data,
                new_vars = new_vars,
                env = env,
                caller = caller,
                call_is_function = call_is_function,
                expr_uses_col = expr_uses_col
              ) |>
                as_polars_expr(as_lit = TRUE)
              if (is.list(rhs)) {
                rhs <- unlist(rhs)
              }
              lhs$is_in(rhs$implode(), nulls_equal = TRUE)
            },
            error = identity
          )
          return(out)
        },
        "base::ifelse" = ,
        "ifelse" = ,
        "dplyr::if_else" = ,
        "if_else" = {
          args <- call_args(expr)
          args$.data <- .data
          args[["__tidypolars__new_vars"]] <- as.list(new_vars)
          args[["__tidypolars__env"]] <- env
          args[["__tidypolars__caller"]] <- caller
          args[["__tidypolars__expr_uses_col"]] <- expr_uses_col
          if ("condition" %in% names(args)) {
            idx <- which(names(args) == "condition")
            names(args)[idx] <- "test"
          }
          if ("true" %in% names(args)) {
            idx <- which(names(args) == "true")
            names(args)[idx] <- "yes"
          }
          if ("false" %in% names(args)) {
            idx <- which(names(args) == "false")
            names(args)[idx] <- "no"
          }
          return(do.call(pl_ifelse, args))
        },

        ### stringr functions
        "stringr::fixed" = ,
        "fixed" = {
          out <- expr[[2]]
          attr(out, "stringr_attr") <- "fixed"
          return(out)
        },
        "stringr::regex" = ,
        "regex" = {
          out <- select_by_name_or_position(expr, "pattern", 1, env = env)
          case_insensitive <- select_by_name_or_position(
            expr,
            "ignore_case",
            2,
            default = FALSE,
            env = env
          )
          names_expr <- names(expr)
          unexpected_names <- setdiff(
            names_expr[names_expr != ""],
            c("pattern", "ignore_case")
          )
          if (length(unexpected_names) > 0) {
            rlang::warn(
              c(
                "tidypolars only supports the argument `ignore_case` in `regex()`.",
                "i" = paste(
                  "Unexpected argument(s):",
                  toString(unexpected_names)
                )
              ),
              call = env
            )
          }
          attr(out, "case_insensitive") <- case_insensitive
          return(out)
        },

        "%>%" = {
          lhs <- expr[[2]]
          rhs <- expr[[3]]
          replace_dot <- function(expr, replacement) {
            if (is.symbol(expr) && identical(expr, sym("."))) {
              return(replacement)
            } else if (is.call(expr)) {
              as.call(lapply(expr, replace_dot, replacement = replacement))
            } else {
              return(expr)
            }
          }

          has_dot <- any(vapply(
            rhs,
            function(x) is.symbol(x) && identical(x, sym(".")),
            FUN.VALUE = logical(1)
          ))

          if (has_dot) {
            new_rhs <- replace_dot(rhs, lhs)
          } else {
            ### I want to insert `lhs` as first arg so first I remove all args
            ### in the original call (after saving them), and then I insert the
            ### new args with `lhs` first.
            existing_args <- call_args(rhs)
            remove_args <- rep_named(names(existing_args), list(zap()))
            new_args <- append(list(lhs), existing_args)
            new_rhs <- rhs
            if (length(remove_args) > 0) {
              new_rhs <- call_modify(new_rhs, !!!remove_args)
            }
            new_rhs <- call_modify(new_rhs, !!!new_args)
          }

          out <- translate(
            new_rhs,
            .data = .data,
            new_vars = new_vars,
            env = env,
            caller = caller,
            call_is_function = call_is_function,
            expr_uses_col = expr_uses_col
          )
          return(out)
        }
      )

      user_defined <- get_user_defined_functions(caller = caller)
      # fmt: skip
      known_ops <- c(
        "+", "-", "*", "/", "^", "**", ">", ">=", "<", "<=", "==", "!=", "&",
        "|", "!", "%%", "%/%"
      )
      fn_names <- add_pkg_suffix(name, known_ops, user_defined)
      name <- fn_names$name_to_eval
      is_known <- is_function_known(name)

      if (!missing(env) && isTRUE(env$is_rowwise)) {
        check_allowed_rowwise(name, env)
      }

      # Evaluate arguments early on because we need to know if the expression
      # contains columns or not.
      # Do not go through this step when:
      # - the function is already translated (allows us to not loop through
      #   all elements, which is expensive)
      # - we have anonymous functions in across()
      obj_name <- quo_name(expr)
      if (
        !is_known &&
          !(name %in% c(known_ops, user_defined)) &&
          !startsWith(obj_name, ".__tidypolars__across_fn")
      ) {
        args <- lapply(
          as.list(expr[-1]),
          translate,
          .data = .data,
          new_vars = new_vars,
          env = env,
          caller = caller,
          call_is_function = call_is_function,
          expr_uses_col = expr_uses_col
        )
        latest_expr_id <- paste0("id", expr_uses_col[["counter"]])

        if (isFALSE(expr_uses_col[[latest_expr_id]])) {
          # Some expressions do not work when called outside of data, e.g. n()
          # must be called only in summarize(), etc.
          out <- try(eval_bare(expr, env = caller), silent = TRUE)
          if (!inherits(out, "try-error")) {
            return(pl$lit(out))
          }
        }
      }

      # If unknown function:
      # - either anonymous function called in across()
      # - or undefined function (typo, not run in the global env, etc.)

      if (!is_known && !(name %in% c(known_ops, user_defined))) {
        if (startsWith(obj_name, ".__tidypolars__across_fn")) {
          fn <- eval_bare(global_env()[[obj_name]])
          col_name <- sym(col_name)
          args <- translate(
            col_name,
            .data = .data,
            env = env,
            new_vars = new_vars,
            caller = caller,
            call_is_function = call_is_function,
            expr_uses_col = expr_uses_col
          )

          suppressWarnings({
            tr <- try(do.call(fn, list(args)), silent = TRUE)
          })
          if (is_polars_expr(tr)) {
            return(tr)
          } else {
            cli_abort(
              c(
                "Could not evaluate an anonymous function in {.fn across}.",
                "i" = "Are you sure the anonymous function returns a Polars expression?"
              ),
              call = env
            )
          }
        } else {
          if (isTRUE(getOption("tidypolars_fallback_to_r", FALSE))) {
            data_df <- as.data.frame(.data)
            out <- eval_tidy(expr, data = data_df)
            return(pl$lit(out))
          }
          if (!is.null(fn_names$pkg)) {
            msg <- "{.pkg tidypolars} doesn't know how to translate this function: {.fn {fn_names$orig_name}} (from package {.pkg {fn_names$pkg}})."
          } else {
            msg <- "{.pkg tidypolars} doesn't know how to translate this function: {.fn {fn_names$orig_name}}."
          }
          # Only suggest opening an issue for functions coming from other pkgs,
          # not for custom functions.
          if (
            !is.null(fn_names$pkg) ||
              grepl("::", fn_names$orig_name, fixed = TRUE)
          ) {
            msg <- c(
              msg,
              i = "You can ask for it to be translated here: {.url https://github.com/etiennebacher/tidypolars/issues}."
            )
          }
          msg <- c(
            msg,
            i = "See {.code ?tidypolars_options} to set automatic fallback to R to handle unknown functions."
          )
          cli_abort(msg, call = env)
        }
      }

      args <- lapply(
        as.list(expr[-1]),
        translate,
        .data = .data,
        new_vars = new_vars,
        env = env,
        caller = caller,
        call_is_function = call_is_function,
        expr_uses_col = expr_uses_col
      )

      tryCatch(
        {
          if (name %in% c(known_ops, user_defined)) {
            call2(name, !!!args) |> eval_bare(env = caller)
          } else {
            accepted_args <- names(formals(name))
            if ("..." %in% accepted_args) {
              args[["__tidypolars__new_vars"]] <- as.list(new_vars)
              args[["__tidypolars__env"]] <- env
              args[["__tidypolars__expr_uses_col"]] <- expr_uses_col
            }
            do.call(name, args)
          }
        },
        error = function(e) {
          if (!inherits(e, "tidypolars_error")) {
            orig_name <- gsub("^pl_", "", name)
            cli_abort(
              c(
                "Error while running function {.fn {fn_names$orig_name}} in Polars.",
                x = e$message,
                e$body
              ),
              call = env
            )
          } else {
            cli_abort(e$message, call = env)
          }
        }
      )
    },
    cli_abort(
      paste("Internal: Unknown type", typeof(expr)),
      call = env
    )
  )
}

get_user_defined_functions <- function(caller) {
  x <- ls(caller)
  list_fns <- list()
  for (i in x) {
    foo <- tryCatch(
      env_get(nm = i, env = caller),
      warning = function(w) invisible(),
      error = function(e) NULL
    )
    if (!missing(foo) && !is.null(foo) && is.function(foo)) {
      list_fns[[i]] <- i
    }
  }
  unlist(list_fns)
}

# Used when I convert R functions to polars functions. E.g warn that na.rm = TRUE
# exists in the R function but will not be used in the polars function.
check_empty_dots <- function(...) {
  dots <- get_dots(...)
  env <- dots[["__tidypolars__env"]]
  dots[["__tidypolars__new_vars"]] <- NULL
  dots[["__tidypolars__env"]] <- NULL
  dots[["__tidypolars__expr_uses_col"]] <- NULL
  dots[["__tidypolars__caller"]] <- NULL

  if (length(dots) == 0) {
    return(invisible())
  }

  fn <- call_match(sys.call(sys.parent()), sys.function(sys.parent())) |>
    call_name()
  fn <- gsub("^pl\\_", "", fn)

  rlang_action <- getOption("tidypolars_unknown_args", "warn")
  if (rlang_action == "warn") {
    cli_warn(
      c(
        "{.pkg tidypolars} doesn't know how to use some arguments of {.fn {fn}}.",
        "i" = "The following argument(s) will be ignored: {.val {names(dots)}}."
      )
    )
  } else if (rlang_action == "error") {
    cli_abort(
      c(
        "{.pkg tidypolars} doesn't know how to use some arguments of {.fn {fn}}: {.val {names(dots)}}.",
        i = "Use {.code options(tidypolars_unknown_args = \"warn\")} to warn when this happens instead of throwing an error."
      ),
      call = env
    )
  } else {
    cli_abort(
      "The global option {.code tidypolars_unknown_args} only accepts \"warn\" and \"error\"."
    )
  }
}

# Drop elements I added myself in translate_expr(). Used only in functions that
# apply directly `...`, such as paste()
clean_dots <- function(...) {
  dots <- get_dots(...)
  dots[["__tidypolars__new_vars"]] <- NULL
  dots[["__tidypolars__env"]] <- NULL
  dots[["__tidypolars__expr_uses_col"]] <- NULL
  dots[["__tidypolars__caller"]] <- NULL
  caller_call <- deparse(rlang::caller_call()[[1]])
  called_from_pl_paste <- length(caller_call) == 1 &&
    caller_call %in% c("pl_paste", "pl_paste0")
  dots <- lapply(dots, function(x) {
    if (
      called_from_pl_paste &&
        inherits(x, c("character", "logical", "double", "integer", "complex"))
    ) {
      pl$lit(x)
    } else {
      x
    }
  })
  dots
}

# Used when I need to call translate_expr() from an internal function (e.g
# pl_ifelse())
new_vars_from_dots <- function(...) {
  dots <- get_dots(...)
  dots[["__tidypolars__new_vars"]]
}

env_from_dots <- function(...) {
  dots <- get_dots(...)
  dots[["__tidypolars__env"]]
}

expr_uses_col_from_dots <- function(...) {
  dots <- get_dots(...)
  dots[["__tidypolars__expr_uses_col"]]
}

expr_uses_col_from_dots <- function(...) {
  dots <- get_dots(...)
  dots[["__tidypolars__expr_uses_col"]]
}

caller_from_dots <- function(...) {
  dots <- get_dots(...)
  dots[["__tidypolars__caller"]]
}

add_pkg_suffix <- function(name, known_ops, user_defined) {
  if (length(name) == 3 && name[[1]] == "::") {
    name <- paste0(name[[2]], "::", name[[3]])
  }
  if (name %in% c(known_ops, user_defined)) {
    return(list(orig_name = name, name_to_eval = name))
  }

  fn <- name

  if (grepl("::", fn, fixed = TRUE)) {
    pkg <- gsub("::.*", "", fn)
    fn <- gsub(".*::", "", fn)
  } else {
    pkg <- tryCatch(
      ns_env_name(as_function(name)),
      error = function(e) {
        return(NULL)
      }
    )
  }

  if (is.null(pkg) || pkg %in% c("base", "stats", "utils", "tools")) {
    name_to_eval <- paste0("pl_", fn)
  } else {
    name_to_eval <- paste0("pl_", fn, "_", pkg)
  }

  if (grepl("::", name, fixed = TRUE)) {
    # Don't store the pkg name if it's explicitly specified.
    # Don't do this too early because we need pkg when building the function to
    # eval.
    pkg <- NULL
  }
  list(orig_name = name, name_to_eval = name_to_eval, pkg = pkg)
}

is_function_known <- function(name) {
  ev <- try(environment(eval(parse(text = name))), silent = TRUE)
  if (inherits(ev, "try-error")) {
    env_tidypolars <- NULL
  } else {
    env_tidypolars <- ev
  }
  !is.null(env_tidypolars[[name]])
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
    # "1 + 1" is of type "language" so I cannot transform the literal values
    # as polars_constant in the translate() function.
    # This is the last moment where I can do it.
    if (
      typeof(exprs[[i]]) %in% c("character", "logical", "integer", "double")
    ) {
      if (!is.list(exprs)) {
        exprs <- as.list(exprs)
      }
      exprs[[i]] <- pl$lit(exprs[[i]])
    }

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

# Check rowwise when we have a named arg (e.g mean(c(x, y)))
check_rowwise <- function(x = NULL, ...) {
  dots <- get_dots(...)
  is_rowwise <- dots[["__tidypolars__env"]]$is_rowwise
  if (is.list(x) && isTRUE(is_rowwise)) {
    out <- pl$concat_list(!!!x)
  } else {
    out <- x
  }
  list(is_rowwise = is_rowwise, expr = out)
}

# Check rowwise when we have dots (e.g sum(x, y, 1, z))
check_rowwise_dots <- function(...) {
  dots <- get_dots(...)
  is_rowwise <- dots[["__tidypolars__env"]]$is_rowwise
  dots[["__tidypolars__new_vars"]] <- NULL
  dots[["__tidypolars__env"]] <- NULL
  dots[["__tidypolars__expr_uses_col"]] <- NULL
  dots[["__tidypolars__caller"]] <- NULL
  dots <- unlist(dots)
  if (isTRUE(is_rowwise)) {
    out <- pl$concat_list(!!!dots)
  } else {
    if (is.list(dots)) {
      out <- dots[[1]]
    } else {
      out <- dots
    }
  }
  list(is_rowwise = is_rowwise, expr = out)
}

# Modify pattern if case insensitive, return info on whether it should be
# literal
check_pattern <- function(x) {
  is_fixed <- isTRUE(attr(x, "stringr_attr") == "fixed")
  is_case_insensitive <- isTRUE(attr(x, "case_insensitive"))
  if (is_case_insensitive) {
    x <- paste0("(?i)", x)
  }
  list(
    pattern = x,
    is_fixed = is_fixed,
    is_case_insensitive = is_case_insensitive
  )
}

polars_expr_to_r <- function(x) {
  if (is_polars_expr(x)) {
    is_col <- length(x$meta$root_names()) > 0
    if (!is_col) {
      x <- pl$select(x)$to_series()$to_r_vector()
    }
  }
  x
}

#' Timezone assertion
#'
#' @description `polars` tzone limitations
#' https://pola-rs.github.io/r-polars/man/ExprDT_convert_time_zone.html
#'
#' @noRd
#' @keywords internal
check_timezone <- function(tz, empty_allowed = FALSE) {
  tz <- polars_expr_to_r(tz)

  # This happens when one passes an existing column as the timezone,
  # polars_expr_to_r() doesn't return an R object in this case.
  if (is_polars_expr(tz)) {
    cli_abort(
      "{.pkg tidypolars} cannot pass a variable of the data as timezone."
    )
  }

  if (length(tz) > 1) {
    cli_abort(
      "{.pkg tidypolars} cannot use several timezones in a single column."
    )
  }

  if (is.na(tz)) {
    cli_abort(
      "This expression in {.pkg tidypolars} doesn't support `NA` timezone."
    )
  }

  if (tz == "") {
    if (empty_allowed) {
      return(NULL)
    } else {
      cli_abort(
        "This expression in {.pkg tidypolars} doesn't support empty timezone."
      )
    }
  }

  if (!tz %in% OlsonNames()) {
    cli_abort("Unrecognized time zone: {.val {tz}}", )
  }

  tz
}

check_allowed_rowwise <- function(name, env) {
  shortlist <- c(
    paste0("pl_", c("mean", "median", "min", "max", "sum", "all", "any")),
    "!"
  )
  if (!name %in% shortlist) {
    cli_abort(
      c(
        "x" = "Can't use function {.fn {name}} in rowwise mode.",
        "i" = "For now, {.fn rowwise} only works on the following functions:",
        "i" = "{.fn mean}, {.fn median}, {.fn min}, {.fn max}, {.fn sum}, {.fn all}, {.fn any}"
      ),
      call = env
    )
  }
}
