#' @export

pl_ifelse <- function(data, cond, yes, no) {

  cond <- substitute(cond)

  # extract variable names from the filtering expressions
  vars <- lapply(list(cond, yes, no), \(x) {
    deparsed <- as.character(x)
    deparsed[which(deparsed %in% pl_colnames(data))]
  }) |>
    unlist() |>
    unique()

  cond <- deparse(cond)
  yes <- deparse(yes)
  no <- deparse(no)

  out <- list(cond = cond, yes = yes, no = no)
  for (i in seq_along(out)) {
    for (j in vars) {
      out[[i]] <- gsub(j, paste0("pl$col('", j, "')"), out[[i]])
    }
  }

  # build the polars expression
  expr <- paste0(
    "pl$when(", out$cond, ")$",
    "then(", out$yes, ")$",
    "otherwise(", out$no, ")$",
    "alias('foo')"
  ) |>
    str2lang()

  data$with_columns(eval(expr))
}
