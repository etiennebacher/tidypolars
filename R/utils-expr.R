# Rearrange classic R expressions in Polars syntax

rearrange_exprs <- function(data, dots) {

  to_drop <- list()

  out <- lapply(seq_along(dots), function(x) {
    if (is.null(dots[[x]])) {
      to_drop[[names(dots)[x]]] <<- 1
      return(NULL)
    }
    deparsed <- deparse(dots[[x]])
    deparsed <- replace_vars_in_expr(data, deparsed)
    new_expr <- replace_funs(deparsed)
    paste0(new_expr, "$alias('", names(dots)[x], "')")
  })

  list(to_drop, out)

}


# Either replace R funs by their Polars equivalent or put the R funs into
# map() or apply()

replace_funs <- function(x) {

  new_x <- x
  funs <- find_function_call_in_string(x)

  for (f in funs$in_polars) {
    new_x <- gsub(paste0(f, "\\("), paste0("pl_", f, "\\("), new_x)
  }

  paste0("(", new_x, ")")
  # Functions that don't have a polars equivalent should go in an apply() call
}



# In a deparsed expression, find the variable names and add pl$col() around
# them

replace_vars_in_expr <- function(data, deparsed) {
  p <- parse(
    text = deparsed,
    keep.source = TRUE
  )
  p_d <- getParseData(p)
  vars_used <- p_d[p_d$token %in% c("SYMBOL"), "text"]
  vars_used <- unique(vars_used[vars_used %in% pl_colnames(data)])

  for (i in vars_used) {
    deparsed <- gsub(i, paste0("pl$col('", i, "')"), deparsed)
  }
  deparsed
}


# In a deparsed expression, find the function calls and show which has an
# equivalent in polars and which hasn't

find_function_call_in_string <- function(x) {

  p <- parse(
    text = x,
    keep.source = TRUE
  )
  p_d <- getParseData(p)

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

