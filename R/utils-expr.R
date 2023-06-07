#' Rearrange classic R expressions in Polars syntax

rearrange_exprs <- function(data, dots) {

  lapply(seq_along(dots), function(x) {

    deparsed <- deparse(dots[[x]])
    deparsed <- replace_vars_in_expr(data, deparsed)

    new_expr <- rearrange_expr(deparsed)
    paste0(new_expr, "$alias('", names(dots)[x], "')")
  })

}


#' Rearrange classic R expressions in Polars syntax

rearrange_expr <- function(x) {

  new_x <- x

  # for each function that has an equivalent in polars, I should
  # extract the inside of the function (which usually is the first arg) and put
  # it in front.

  funs <- find_function_call_in_string(x)

  for (f in funs$in_polars) {
    full_f <- regmatches(
      new_x,
      gregexpr(paste0(f, "\\((?<text>[^ ]*)\\)\\)"), new_x, perl = TRUE)
    )
    full_f2 <- gsub(paste0("^", f, "\\("), "", full_f)
    full_f2 <- gsub("\\)$", "", full_f2)
    full_f2 <- paste0(full_f2, "$", f, "()")
    new_x <- gsub(paste0(f, "\\((?<text>[^ ]*)\\)\\)"), full_f2, new_x, perl = TRUE)
  }

  paste0("(", new_x, ")")

  # Functions that don't have a polars equivalent should go in an apply() call
}



#' In a deparsed expression, find the variable names and add pl$col() around
#' them

replace_vars_in_expr <- function(data, deparsed) {
  p <- parse(
    text = deparsed,
    keep.source = TRUE
  )
  p_d <- getParseData(p)
  vars_used <- p_d[p_d$token %in% c("SYMBOL"), "text"]
  vars_used <- vars_used[vars_used %in% pl_colnames(data)]

  for (i in vars_used) {
    deparsed <- gsub(i, paste0("pl$col('", i, "')"), deparsed)
  }
  deparsed
}


#' In a deparsed expression, find the function calls and show which has an
#' equivalent in polars and which hasn't

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

  pl_exprs <- get_polars_expr()

  list(
    in_polars = function_calls[function_calls %in% pl_exprs$expr],
    not_in_polars = function_calls[!function_calls %in% pl_exprs$expr]
  )

}

