check_polars_data <- function(x, env = caller_env()) {
  if (!inherits(x, "RPolarsDataFrame") && !inherits(x, "RPolarsLazyFrame")) {
    rlang::abort(
      "The data must be a Polars DataFrame or LazyFrame.",
      call = env
    )
  }
  x <- x$clone()
  add_tidypolars_class(x)
}

add_tidypolars_class <- function(x) {
  if (!inherits(x, "tidypolars")) {
    class(x) <- c("tidypolars", class(x))
  }
  x
}

add_tidypolars_expr_class <- function(x) {
  if (!inherits(x, "tidypolars_expr")) {
    class(x) <- c("tidypolars_expr", class(x))
  }
  x
}


check_same_class <- function(x, y, env = caller_env()) {
  if (class(x) != class(y)) {
    rlang::abort(
      c(
        "Both objects must be of the same class.",
        "i" = paste0("Currently, `x` is a ", class(x)[1], " and `y` is a ", class(y)[1], ".")
      ),
      call = env
    )
  }
}


modify_this_polars_function <- function(env, fun_name, data, caller_env) {
  fun <- env[[fun_name]]
  function(...) {

    # Manually add the "self" argument, that will take the data from
    # `$.tidypolars`. Otherwise, the "self" value in the Polars function is
    # unknown when we execute this function below.
    fmls <- fn_fmls(fun)
    fmls[[length(fmls) + 1]] <- quote(expr = )
    names(fmls)[length(fmls)] <- "self"
    formals(fun) <- fmls

    # Evaluate the args that are passed to the Polars function, e.g what is
    # passed to `.data$sort()` in arrange.RPolarsDataFrame().
    # First we capture unevaluated args, then we evaluate each of them in the
    # caller env, which would be the env in arrange.RPolarsDataFrame() for
    # example.

    fc <- as.list(frame_call())
    fc1 <- fc[[1]]
    fc[[1]] <- NULL
    inner_expr <- NULL
    fc <- lapply(fc, \(x) {
      # if (fun_name == "filter") browser()
      if (is.call(x)) {
        foo <- eval_bare(x, env = caller_env)
        attrs <- attributes(foo)$polars_expression |>
          unlist() |>
          paste(collapse = "") |>
          parse_expr()
        return(attrs)
      } else {
        if (deparse(x) == "...") return(NULL)
        foo <- eval_bare(x, env = caller_env)
        if (fun_name %in%  c("filter", "with_columns")) {
          if (is.list(foo)) {
            inner_expr <- lapply(seq_along(foo), function(expr_idx) {
              d <- attributes(foo[[expr_idx]])$polars_expression
              gsub("^[^\\$]\\$", "$", d) |>
                paste(collapse = "") |>
                parse_expr()
            })
          } else {
            attrs <- attributes(foo)$polars_expression
            inner_expr <- lapply(seq_along(attrs), function(d) {
              if (d == 1) return(attrs[[d]])
              gsub("^[^\\$]\\$", "$", attrs[[d]])
            }) |>
              unlist() |>
              paste(collapse = "") |>
              parse_expr() |>
              list()
          }
          names(inner_expr) <- names(foo)
          inner_expr <<- inner_expr
        }
        foo
      }
    })
    fc <- drop_empty_unnamed(fc)

    # Prepare the call that will be stored in the attributes of the output so
    # that show_query() can access it.
    args <- list2(...)
    if (!is.null(inner_expr)) {
      full_call <- call2(fc1, !!!inner_expr)
    } else {
      full_call <- call2(fc1, !!!fc)
    }
    full_call <- safe_deparse(full_call)

    # Evaluate the call to the polars function. Do this AFTER producing the
    # call that will be stored in the attributes because the value of "data"
    # is strange when we call RPolarsGroupBy methods.
    fc[["self"]] <- data
    out <- call2(fun, !!!fc) |> eval_bare()

    # If the attribute to store the "pure" polars expressions already exists,
    # we append the next expressions to it.
    attr_pl <- attr(data, "polars_expression")
    if (is.null(attr_pl)) {
      attr(out, "polars_expression") <- list(full_call)
    } else {
      attr(out, "polars_expression") <- attr_pl

      # What happens when there are several calls chained together?
      # For example, if the call is `dat$group_by(xxx)$agg(xxx)`, then the
      # groupby() call is returned twice: once because its on the RHS of `$`,
      # and once because it's on its LHS.

      # Therefore, I count the number of `$` in the chain. If there are several,
      # I remove everything before the last occurrence of `$agg()` because
      # we only want to increment the list of calls with this last occurrence.

      n_dollars <- sum(gregexpr("\\$", full_call)[[1]] > 0)
      if (n_dollars > 1) {
        full_call <- gsub(paste0(".*(\\$", fun_name, ")"), "\\1", full_call)
      }
      attr(out, "polars_expression")[[length(attr_pl) + 1]] <- full_call
    }
    add_tidypolars_class(out)
  }
}


# Very similar to the one above but applies only to RPolarsExpr.
# We want to transform "pl$len()$alias(name)$over(vars)" to
# "pl$len()$alias('n')$over('cyl')".
#
# One of the differences with the one above is that we don't return an object
# of class tidypolars.
#
# This one should only be called from modify_env() and we will only use the
# attributes of the output RPolarsExpr.

modify_this_polars_expr <- function(env, fun_name, data, out, caller_env) {
  fun <- env[[fun_name]]

  subns <- c("bin", "cat", "dt", "meta", "str", "struct")
  if (fun_name %in% subns) {
    fmls <- fn_fmls(fun)
    fmls[[length(fmls) + 1]] <- quote(expr = )
    names(fmls)[length(fmls)] <- "self"
    formals(fun) <- fmls
    out <- add_tidypolars_expr_class(fun(data))
    return(out)
  }

  function(...) {

    # Manually add the "self" argument, that will take the data from
    # `$.tidypolars`. Otherwise, the "self" value in the Polars function is
    # unknown when we execute this function below.
    fmls <- fn_fmls(fun)
    fmls[[length(fmls) + 1]] <- quote(expr = )
    names(fmls)[length(fmls)] <- "self"
    formals(fun) <- fmls

    # Evaluate the args that are passed to the Polars function, e.g what is
    # passed to `.data$sort()` in arrange.RPolarsDataFrame().
    # First we capture unevaluated args, then we evaluate each of them in the
    # caller env, which would be the env in arrange.RPolarsDataFrame() for
    # example.
    fc <- as.list(frame_call())
    fc1 <- fc[[1]]
    fc[[1]] <- NULL
    inner_expr <- NULL
    fc <- lapply(fc, \(x) {
      foo <- eval_bare(x, env = caller_env)
      if (! fun_name %in% c("DataFrame", "col", "lit")) {
        if (is.list(foo)) {
          inner_expr <- lapply(seq_along(foo), function(expr_idx) {
            parse_expr(attributes(foo[[expr_idx]])$polars_expression[[1]])
          })
        } else {
          attrs <- attributes(foo)$polars_expression
          if (!is.null(attrs)) {
            inner_expr <- lapply(seq_along(attrs), function(d) {
              if (d == 1) return(attrs[[d]])
              gsub("^[^\\$]\\$", "$", attrs[[d]])
            }) |>
              unlist() |>
              paste(collapse = "") |>
              parse_expr() |>
              list()
          }
          names(inner_expr) <- names(foo)
        }
        inner_expr <<- inner_expr
      }
      foo
    })

    # Prepare the call that will be stored in the attributes of the output so
    # that show_query() can access it.
    args <- list2(...)
    if (!is.null(inner_expr)) {
      full_call <- call2(fc1, !!!inner_expr)
    } else {
      full_call <- call2(fc1, !!!fc)
    }
    full_call <- safe_deparse(full_call)

    # Evaluate the call to the polars function. Do this AFTER producing the
    # call that will be stored in the attributes because the value of "data"
    # is strange when we call RPolarsGroupBy methods.
    fc[["self"]] <- data

    if (is.null(out)) {
      out <- call2(fun, !!!fc) |> eval_bare()
    }

    # If the attribute to store the "pure" polars expressions already exists,
    # we append the next expressions to it.
    attr_pl <- attr(data, "polars_expression")
    if (is.null(attr_pl)) {
      attr(out, "polars_expression") <- list(full_call)
    } else {
      attr(out, "polars_expression") <- attr_pl

      # What happens when there are several calls chained together?
      # For example, if the call is `dat$group_by(xxx)$agg(xxx)`, then the
      # groupby() call is returned twice: once because its on the RHS of `$`,
      # and once because it's on its LHS.

      # Therefore, I count the number of `$` in the chain. If there are several,
      # I remove everything before the last occurrence of `$agg()` because
      # we only want to increment the list of calls with this last occurrence.

      n_dollars <- sum(gregexpr("\\$", full_call)[[1]] > 0)
      if (n_dollars > 1) {
        full_call <- gsub(paste0(".*(\\$", fun_name, ")"), "\\1", full_call)
      }
      attr(out, "polars_expression")[[length(attr_pl) + 1]] <- full_call
    }
    if (inherits(out, c("RPolarsDataFrame", "RPolarsLazyFrame"))) {
      add_tidypolars_class(out)
    } else if (inherits(out, c("RPolarsExpr", "RPolarsWhen", "RPolarsThen", "RPolarsGroupBy", "RPolarsLazyGroupBy"))) {
      add_tidypolars_expr_class(out)
    }
  }
}

# I need to add the "tidypolars_expr" manually because all (?) Polars expr
# will start with pl$ and it has to go through "$.tidypolars_expr".
pl <- lapply(env_clone(polars:::pl), add_tidypolars_expr_class) |>
  as.environment() |>
  add_tidypolars_expr_class()
