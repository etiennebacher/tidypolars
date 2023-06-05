#' Rearrange classic R expressions in Polars syntax

rearrange_exprs <- function(data, expressions) {
  lapply(seq_along(expressions), \(x) {
    x_expr <- expressions[[x]]
    var_name <- names(expressions)[x]
    deparsed <- deparse(x_expr)

    vars_used <- unlist(lapply(x_expr, as.character))
    vars_used <- unique(vars_used[which(vars_used %in% pl_colnames(data))])

    browser()

    for (i in vars_used) {
      deparsed <- sub(i, "", deparsed, fixed = TRUE)
      deparsed <- paste0("pl$col('", i, "')$", deparsed)
      deparsed <- gsub("\\(\\s+,", "", deparsed)
      deparsed <- gsub("\\s+,\\)", "", deparsed)
    }

    deparsed <- paste0(deparsed, "$alias('", var_name, "')")

    # pl_funs <- regmatches(deparsed, gregexpr("pl\\_\\w+", deparsed))

    deparsed
  })
}
