# largely inspired from dplyr/across.R

unpack_across <- function(.data, expr) {
  .cols <- get_arg(".cols", 1, expr)
  .cols <- tidyselect_named_arg(.data, enquo(.cols))
  .fns <- get_arg(".fns", 2, expr)
  .names <- get_arg(".names", 3, expr)

  validate <- function(x) {
    if (is_formula(x) || is_function(x)) {
      if (is_inlinable_function(x)) {
        return(set_env(x, empty_env()))
      }

      if (is_inlinable_formula(x)) {
        mask <- new_data_mask(bottom = global_env())
        fn <- new_function(pairlist2(.x = ), f_rhs(x), env = mask)
        return(fn)
      }

      # Can't inline the lambda. We set its environment to the data
      # mask so it can still refer to columns.
      x <- set_env(x, mask)
      as_function(x, arg = ".fns", call = error_call)

    } else if (as_string(x) %in% unlist(known_functions())) {
      x
    } else {
      abort(
        "`.fns` must be a function, a formula, or a list of functions/formulas.",
        call = error_call
      )
    }
  }

  if (is.list(.fns)) {
    .fns <- map(.fns, function(elt) validate(elt))
  } else {
    .fns <- list(validate(.fns))
  }

  build_separate_calls(.cols, .fns, .names, .data)
}


build_separate_calls <- function(.cols, .fns, .names, .data) {
  list_calls <- list()
  for (i in seq_along(.cols)) {
    for (j in seq_along(.fns)) {
      if (!is.null(.names) && length(.names) == 1) {
        nm <- gsub("{\\.col}", .cols[i], .names, perl = TRUE)
        if (is.null(names(.fns)[j])) {
          nm <- gsub("{\\.fn}", j, nm, perl = TRUE)
        } else {
          nm <- gsub("{\\.fn}", names(.fns)[j], nm, perl = TRUE)
        }
      } else {
        nm <- .cols[i]
      }
      arg <- sym(.cols[i])
      list_calls[[nm]] <- translate_expr(call2(.fns[[j]], arg), .data)
    }
  }
  list_calls
}

is_inlinable_formula <- function(x) {
  if (!is_formula(x, lhs = FALSE)) {
    return(FALSE)
  }
  # Don't inline if there are additional arguments passed through `...`
  nms <- all.names(x)
  unsupported_arg_rx <- "\\.\\.[0-9]|\\.y"

  if (any(grepl(unsupported_arg_rx, nms))) {
    return(FALSE)
  }

  # Don't inline lambdas that call `return()` at the moment, see above
  if ("return" %in% nms) {
    return(FALSE)
  }

  TRUE
}

is_inlinable_function <- function(x) {
  if (!is_function(x)) {
    return(FALSE)
  }
  fmls <- formals(x)

  # Don't inline if there are additional arguments even if they have
  # defaults or are passed through `...`
  if (length(fmls) != 1) {
    return(FALSE)
  }

  # Don't inline lambdas that call `return()` at the moment a few
  # packages do things like `across(1, function(x)
  # return(x))`. Whereas `eval()` sets a return point, `eval_tidy()`
  # doesn't which causes `return()` to throw an error.
  if ("return" %in% all.names(body(x))) {
    return(FALSE)
  }

  TRUE
}

# extract arg from across(), either from name or position
get_arg <- function(name, position, list) {
  if (name %in% names(list)) {
    list[[name]]
  } else {
    # I provide the position in across() but the call to "across" takes the
    # first slot of the list
    if (position + 1 <= length(list)) {
      list[[position + 1]]
    }
  }
}
