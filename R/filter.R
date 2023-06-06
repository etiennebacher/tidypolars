#' @export

pl_filter <- function(data, ...) {

  check_polars_data(data)
  dots <- get_dots(...)

  # extract variable names from the filtering expressions
  vars <- lapply(dots, \(x) {
    deparsed <- unlist(lapply(x, as.character))
    deparsed[which(deparsed %in% pl_colnames(data))]
  }) |>
    unlist() |>
    unique()

  # build the polars expression
  expr <- as.character(dots)
  for (i in seq_along(expr)) {
    has_pl_special_filter <- grepl(
      paste0(
        "(", paste(pl_special_filter_expr(), collapse = "|"), ")\\("
      ),
      expr[i]
    )

    if (has_pl_special_filter) {
      expr[i] <- reorder_filter_expr(expr[i])
    }

    for (v in vars) {
      expr[i] <- gsub(v, paste0("pl\\$col('", v, "')"), expr[i])
    }
  }

  expr <- paste(expr, collapse = " & ") |>
    str2lang()

  data$filter(eval(expr))
}


pl_special_filter_expr <- function() {
  c(
    "!is.nan",
    "is.nan",
    "!is.na",
    "is.na",
    "%in%"
  )
}


reorder_filter_expr <- function(expr) {
  is_negated <- startsWith(expr, "!")
  if (is_negated) {
    expr <- sub("^!", "", expr)
  }
  expr <- str2lang(expr)

  var_name <- deparse(expr[[2]])
  fn_name <- if (is_negated) {
    paste0("!", deparse(expr[[1]]))
  } else {
    deparse(expr[[1]])
  }
  fn_name <- switch(
    fn_name,
    "!is.na" = "is_not_null",
    "is.na" = "is_null",
    "!is.nan" = "is_not_nan",
    "is.nan" = "is_nan"
  )
  paste0(var_name, "$", fn_name, "()")
}
