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
  function_calls <- function_calls[function_calls %in% pl_exprs$expr]
  function_calls

  # once this is done, for each function that has an equivalent in polars, I should
  # extract the inside of the function (which usually is the first arg) and put
  # it in front.
  #
  # Functions that don't have a polars equivalent should go in an apply() call

}
