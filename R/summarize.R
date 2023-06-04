#' @export

pl_summarize <- function(data, ...) {


  #### agg() requires groupby()



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
    vars_used <- unique(vars_used[which(vars_used %in% data$columns)])

    pl_funs <- regmatches(deparsed, gregexpr("pl\\_\\w+", deparsed))

    list(var_name = var_name, vars_used = vars_used, pl_funs = pl_funs,
         call = deparsed)
  })

  out_exprs <- list()
  for (i in seq_along(exprs)) {
    new_call <- gsub("^pl\\_", "", exprs[[i]]$call)
    new_call <- gsub(exprs[[i]]$vars_used, "", new_call)
    new_call <- gsub("\\(,", "\\(", new_call)

    out_exprs[[i]] <- paste0(
      "pl$col('", exprs[[i]]$vars_used, "')$",
      new_call
    )
  }

  out <- paste(unlist(out_exprs), collapse = ", ") |>
    str2lang()

  print(out)

  if (inherits(data, "DataFrame")) {
    data$agg(eval(out))
  }

}
