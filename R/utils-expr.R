#' Rearrange classic R expressions in Polars syntax

rearrange_exprs <- function(data, expressions) {
  lapply(seq_along(expressions), \(x) {
    x_expr <- expressions[[x]]
    var_name <- names(expressions)[x]
    deparsed <- deparse(x_expr)

    deparsed <- replace_vars_in_expr(data, x_expr, deparsed)

    # pl_funs <- regmatches(deparsed, gregexpr("pl\\_\\w+", deparsed))

    deparsed
  })
}



#' In a deparsed expression, find the variable names and add pl$col() around
#' them

replace_vars_in_expr <- function(data, expression, deparsed) {
  vars_used <- unlist(lapply(expression, as.character))
  vars_used <- unique(vars_used[which(vars_used %in% pl_colnames(data))])

  for (i in vars_used) {
    deparsed <- gsub(i, paste0("pl$col('", i, "')"), deparsed)
  }
  deparsed
}
