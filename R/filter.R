#' @export

pl_filter <- function(data, ...) {

  dots <- get_dots(...)
  vars <- lapply(dots, \(x) {
    deparsed <- vapply(x, as.character, FUN.VALUE = character(1L))
    deparsed[which(deparsed %in% colnames(data))]
  }) |>
    unlist() |>
    unique()

  expr <- as.character(dots)
  for (i in vars) {
    expr <- gsub(i, paste0("pl\\$col('", i, "')"), expr)
  }

  expr <- paste(expr, collapse = " & ") |>
    str2lang()

  if (inherits(data, "DataFrame")) {
    data$filter(eval(expr))
  }

}





