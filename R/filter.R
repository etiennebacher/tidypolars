#' @export

pl_filter <- function(data, ...) {

  dots <- get_dots(...)

  # extract variable names from the filtering expressions
  vars <- lapply(dots, \(x) {
    deparsed <- unlist(lapply(x, as.character))
    deparsed[which(deparsed %in% data$columns)]
  }) |>
    unlist() |>
    unique()

  # build the polars expression
  expr <- as.character(dots)
  for (i in vars) {
    expr <- gsub(i, paste0("pl\\$col('", i, "')"), expr)
  }

  expr <- paste(expr, collapse = " & ") |>
    str2lang()

  # perform the expression if eager eval
  if (inherits(data, "DataFrame")) {
    data$filter(eval(expr))
  }

}





