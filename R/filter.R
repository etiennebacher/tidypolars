#' @export

pl_filter <- function(data, ...) {

  check_polars_data(data)
  dots <- get_dots(...)

  expr <- rearrange_exprs(data, dots, create_new = FALSE)[[2]] |>
    unlist()

  if (length(expr) == 1) {
    expr <- unlist(expr)
  } else {
    expr <- unlist(expr)
  }

  for (i in seq_along(expr)) {
    tmp <- expr[i]
    OPERATION <- NULL

    # if there are boolean operators we need to split the string by them, do
    # the syntax conversion separately and add them back
    if (grepl("\\|", tmp)) {
      tmp <- strsplit(tmp, "\\|")[[1]] |>
        trimws()
      OPERATION <- "|"
    }

    # deal with special functions is.na, is.nan, etc.
    for (j in seq_along(tmp)) {
      has_pl_special_filter <- grepl(
        paste0(
          "(", paste(pl_special_filter_expr(), collapse = "|"), ")\\("
        ),
        tmp[j]
      )

      if (has_pl_special_filter) {
        tmp[j] <- reorder_filter_expr(tmp[j])
      }
    }

    expr[i] <- paste(tmp, collapse = OPERATION)
  }

  expr <- paste(expr, collapse = " & ") |>
    str2lang()

  data$filter(eval(expr))
}

#' @export
filter.DataFrame <- pl_filter


pl_special_filter_expr <- function() {
  c(
    "!is.nan",
    "!is.na",
    "is.nan",
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
