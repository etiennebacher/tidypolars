#' @export

pl_mutate <- function(data, ...) {

  check_polars_data(data)

  dots <- get_dots(...)

  exprs <- lapply(seq_along(dots), \(x) {
    # need to output several things:
    # - the name of the new (or modified var)
    # - the name of the variables used in the computation
    # - the name of the polars functions used in the computation

    x_expr <- dots[[x]]
    var_name <- names(dots)[x]
    deparsed <- deparse(x_expr)

    vars_used <- unlist(lapply(x_expr, as.character))
    vars_used <- unique(vars_used[which(vars_used %in% pl_colnames(data))])

    pl_funs <- regmatches(deparsed, gregexpr("pl\\_\\w+", deparsed))

    list(var_name = var_name, vars_used = vars_used, pl_funs = pl_funs,
         call = deparsed)
  })

  # modify expressions:
  # - replace "var" by "pl$col('var')"
  # - put the whole expression between parenthesis
  # - add alias
  out_exprs <- list()
  for (i in seq_along(exprs)) {
    tmp <- exprs[[i]]

    new_call <- gsub("^pl\\_", "", tmp$call)

    for (j in seq_along(tmp$vars_used)) {
      new_call <- gsub(
        tmp$vars_used[j],
        paste0("pl$col('", tmp$vars_used[j], "')"),
        new_call
      )
    }
    new_call <- gsub("\\(,", "\\(", new_call)

    out_exprs[[i]] <- paste0(
      "(",
      new_call,
      ")$alias('", tmp$var_name, "')"
    )
  }

  out <- paste(unlist(out_exprs), collapse = ", ") |>
    str2lang()

  data$with_columns(eval(out))
}
