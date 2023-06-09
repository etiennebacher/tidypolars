# Rearrange classic R expressions in Polars syntax

rearrange_exprs <- function(.data, dots, create_new = TRUE) {

  to_drop <- list()

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

  list(to_drop, out)

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

  if (length(funs$in_polars) == 0 &&
      length(funs$not_in_polars) == 0 &&
      length(new_x) == 1) {
    new_x <- paste0("pl$lit(", new_x, ")")
  }

  if (isTRUE(create_new)) {
    paste0("(", new_x, ")")
  } else {
    new_x
  }
  # Functions that don't have a polars equivalent should go in an apply() call
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

  function_calls <- p_d[p_d$token %in% c("SYMBOL_FUNCTION_CALL", "'+'", "'-'"), "text"]

  if ("col" %in% function_calls) {
    char_before_call <- regmatches(p, gregexpr(".[col]", p))[[1]]
    char_before_call <- char_before_call[char_before_call != ""]
    if (all(substr(char_before_call, 1, 1) == "$")) {
      function_calls <- function_calls[function_calls != "col"]
    }
  }

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
    warning(paste0("\nWhen the dataset is a Polars DataFrame or LazyFrame, `", fn, "` only needs one argument. Additional arguments will not be used."), call. = FALSE)
  }
}

