check_polars_data <- function(x, env = caller_env()) {
  if (!inherits(x, "RPolarsDataFrame") && !inherits(x, "RPolarsLazyFrame")) {
    rlang::abort(
      "The data must be a Polars DataFrame or LazyFrame.",
      call = env
    )
  }
}

add_tidypolars_class <- function(x) {
  if (!inherits(x, "tidypolars")) {
    class(x) <- c("tidypolars", class(x))
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


modify_env <- function(data, env) {
  eapply(env, function(fun) {
    marker <- identical(fun, polars:::RPolarsDataFrame[["sort"]])
    function(...) {
      # if (marker) browser()
      fmls <- fn_fmls(fun)
      fmls[[length(fmls) + 1]] <- quote(expr = )
      names(fmls)[length(fmls)] <- "self"
      formals(fun) <- fmls

      args = list2(...)
      expr = call2(quote(fun), !!!args)
      fc = as.list(frame_call())
      fc1 = fc[[1]]
      fc[[1]] <- NULL
      fc <- lapply(fc, eval_bare, env = caller_env())
      full_call <- call2(fc1, !!!fc)
      fc[["self"]] <- data
      # assign(
      #   as.character(length(expr_env) + 1),
      #   full_call,
      #   envir = expr_env
      # )
      out = call2(fun, !!!fc) |> eval_bare()
      attr_pl <- attr(data, "polars_expression")
      if (is.null(attr_pl)) {
        attr(out, "polars_expression") <- list(full_call)
      } else {
        attr(out, "polars_expression") <- attr_pl
        attr(out, "polars_expression")[[length(attr_pl) + 1]] <- full_call
      }
      add_tidypolars_class(out)
    }
  })
}
