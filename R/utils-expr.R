# Rearrange classic R expressions in Polars syntax

rearrange_exprs <- function(.data, dots, create_new = TRUE) {

  to_drop <- list()

  # if there's an across expression, I "explode" it e.g
  #   'across(contains("a"), mean)'
  # becomes
  #   'carb = mean(carb),
  #    am = mean(am),
  #    ...
  for (i in seq_along(dots)) {
    expr <- dots[[i]]
    if (is.null(expr)) next
    deparsed <- safe_deparse(expr)
    is_across_expr <- startsWith(deparsed, "across(")
    if (is_across_expr) {
      dots[[i]] <- unnest_across_expr(expr, .data)
    }
  }

  if (any(vapply(dots, is.list, FUN.VALUE = logical(1L)))) {
    dots <- unlist(dots, recursive = FALSE)
  }

  out <- lapply(seq_along(dots), function(x) {
    if (is.null(dots[[x]])) {
      to_drop[[names(dots)[x]]] <<- 1
      return(NULL)
    }
    deparsed <- safe_deparse(dots[[x]])
    deparsed <- replace_vars_in_expr(.data, deparsed)
    new_expr <- replace_funs(deparsed, create_new = create_new)
    if (isTRUE(create_new)) {
      paste0(new_expr, "$alias('", names(dots)[x], "')")
    } else {
      new_expr
    }
  })

  list(to_drop = to_drop, out = out)

}


# Either replace R funs by their Polars equivalent or put the R funs into
# map() or apply()

replace_funs <- function(x, create_new = TRUE) {

  new_x <- x
  funs <- find_function_call_in_string(x)

  for (f in unique(funs$in_polars)) {
    replacement <- r_polars_funs[r_polars_funs$r_funs == f, "polars_funs"]

    # a bit hacky but usually when two functions have the same name we want
    # to prefer the one from Polars "default" namespace
    if (length(replacement) > 1) {
      replacement <- replacement[1]
    }
    new_x <- gsub(paste0(f, "\\("), paste0("pl_", replacement, "\\("), new_x)
  }

  contains_in <- grepl("%in%", new_x, perl = TRUE)
  is_preceded_by_casewhen <- grepl("(?=.*case\\_when\\()(.*%in%)", new_x, perl = TRUE)

  if (contains_in && !is_preceded_by_casewhen) {
    new_x <- parse_boolean_exprs(new_x)
  } else {
    can_return <<- TRUE
  }

  if (length(funs$in_polars) == 0 &&
      length(funs$not_in_polars) == 0 &&
      length(new_x) == 1) {
    new_x <- paste0("pl$lit(", new_x, ")")
  }

  is_polars_expr <- inherits(
    try(eval(str2lang(new_x)), silent = TRUE),
    "Expr"
  )

  if (is_polars_expr || can_return) {
    if (isTRUE(create_new)) {
      paste0("(", new_x, ")")
    } else {
      new_x
    }
  } else {
    rlang::abort("Can't evaluate expression")
  }
}



# In a deparsed expression, find the variable names and add pl$col() around
# them

replace_vars_in_expr <- function(.data, deparsed) {
  p <- parse(
    text = deparsed,
    keep.source = TRUE
  )
  p_d <- utils::getParseData(p)
  vars_used <- p_d[p_d$token %in% c("SYMBOL"), "text"]
  vars_used <- unique(vars_used[vars_used %in% pl_colnames(.data)])

  p_d_2 <- p_d
  for (i in vars_used) {
    p_d_2[p_d_2$text == i, "text"] <- paste0("pl$col('", i, "')")
  }

  # just prettier when I need to see the expression to debug
  # p_d_2[p_d_2$text == ",", "text"] <- ", "

  paste(p_d_2$text, collapse = "")
}


# In a deparsed expression, find the function calls and show which has an
# equivalent in polars and which hasn't

find_function_call_in_string <- function(x) {

  p <- parse(
    text = x,
    keep.source = TRUE
  )
  p_d <- utils::getParseData(p)

  function_calls <- p_d[
    p_d$token %in% c("SYMBOL_FUNCTION_CALL", "'+'", "'-'") |
      p_d$text == "%in%",
    "text"
  ]

  pl_exprs <- r_polars_funs

  list(
    in_polars = function_calls[function_calls %in% pl_exprs$r_funs],
    not_in_polars = function_calls[!function_calls %in% pl_exprs$r_funs]
  )

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

# Convert an across() call to a list of calls

unnest_across_expr <- function(expr, .data) {

  if (".cols" %in% names(expr)) {
    .cols <- expr[[".cols"]]
  } else {
    .cols <- expr[[2]]
  }

  if (".fns" %in% names(expr)) {
    .fns <- expr[[".fns"]]
  } else {
    .fns <- expr[[3]]
  }

  if (".names" %in% names(expr)) {
    .names <- expr[[".names"]]
  } else if (length(expr) >= 4) {
    .names <- expr[[4]]
  } else {
    .names <- NULL
  }

  .cols <- tidyselect_named_arg(.data, .cols)

  out <- vector("list", length = length(.cols))
  names(out) <- .cols

  if (length(.fns) == 1) { # just a function name, e.g .fns = mean
    for (i in .cols) {
      out[[i]] <- paste0(.fns, "(", i, ")") |>
        str2lang()
    }
  } else if (length(.fns) == 2) { # anonymous function, e.g .fns = ~mean(.x)
    dep <- safe_deparse(.fns[[2]])
    for (i in .cols) {
      out[[i]] <- gsub("\\(\\.x,", paste0("\\(", i, ","), dep)
      out[[i]] <- gsub("\\(\\.x\\)", paste0("\\(", i, "\\)"), out[[i]])
      out[[i]] <- gsub(",\\.x\\),", paste0(",", i, "\\)"), out[[i]])
      out[[i]] <- str2lang(out[[i]])
    }
  } else { # TODO: function that I can't convert to polars, e.g .fns = function(x) mean(x)
    rlang::abort("Anonymous functions are not supported in `across()` for now.")
  }

  # modify names of new variables if necessary
  if (!is.null(.names)) {
    if (grepl("{\\.fn}", .names, perl = TRUE) && length(.fns) > 2) {
      rlang::abort("Can't use `{.fn}` in argument `.names` of `across()` with anonymous functions.")
    }
    if (length(.fns) == 2) {
      .fns <- .fns[[2]][1]
    }
    for (i in seq_along(out)) {
      new_name <- gsub("{\\.col}", .cols[[i]], .names, perl = TRUE)
      new_name <- gsub("{\\.fn}", .fns, new_name, perl = TRUE)
      names(out)[[i]] <- new_name
    }
  }

  unlist(out)
}



build_polars_exprs <- function(.data, ...) {
  dots <- get_dots(...)
  exprs <- rearrange_exprs(.data, dots)
  to_drop <- names(exprs$to_drop)

  exprs <- Filter(Negate(is.null), exprs$out)
  exprs <- unlist(exprs)
  exprs <- paste(exprs, collapse = ", ")

  list(exprs = exprs, to_drop = to_drop)
}
