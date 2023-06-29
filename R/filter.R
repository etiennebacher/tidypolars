#' Keep rows that match a condition
#'
#' This function is used to subset a data frame, retaining all rows that satisfy
#' your conditions. To be retained, the row must produce a value of TRUE for all
#' conditions. Note that when a condition evaluates to NA the row will be
#' dropped, unlike base subsetting with `[`.
#'
#' @param data A Polars Data/LazyFrame
#' @param ... Expressions that return a logical value, and are defined in terms
#' of the variables in the data. If multiple expressions are included, they
#' will be combined with the & operator. Only rows for which all conditions
#' evaluate to `TRUE` are kept.
#'
#' @export
#' @examples
#' pl_iris <- polars::pl$DataFrame(iris)
#'
#' pl_filter(pl_iris, Sepal.Length < 5 & Species == "setosa")
#'
#' pl_filter(pl_iris, Sepal.Length < Sepal.Width + Petal.Length)
#'
#' pl_filter(pl_iris, Species == "setosa" | is.na(Species))
#'
#' pl_filter(pl_iris, between(Sepal.Length, 5, 6, include_bounds = FALSE))
#'
#' iris2 <- iris
#' iris2$Species <- as.character(iris2$Species)
#' iris2 |>
#'   as_polars() |>
#'   pl_filter(Species %in% c("setosa", "virginica"))
#'

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
    } else if (grepl("\\&", tmp)) {
      tmp <- strsplit(tmp, "\\&")[[1]] |>
        trimws()
      OPERATION <- "&"
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
      if (grepl("%in%", tmp[j])) {
        tmp[j] <- replace_in_operator(tmp[j])
      }
    }

    expr[i] <- paste(tmp, collapse = OPERATION)
  }

  expr <- paste(expr, collapse = " & ")

  # the code for grouped data uses $over() inside $filter(), which
  # cannot be used with grouped data. Therefore I have to manually ungroup
  # the data
  is_grouped <- !is.null(attributes(data)$pl_grps)
  mo <- attributes(data)$private$maintain_order

  if (is_grouped) {
    data2 <- clone_grouped_data(data)
    grps <- attributes(data2)$pl_grps
    if (inherits(data2, "GroupBy")) {
      attributes(data2)$class <- "DataFrame"
    } else {
      attributes(data2)$class <- "LazyFrame"
    }
    expr <- paste0(expr, "$over(grps)")
  }

  expr <- str2lang(expr)

  out <- data$filter(eval(expr))

  if (is_grouped) {
    out$groupby(grps, maintain_order = mo)
  } else {
    out
  }
}


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

replace_in_operator <- function(expr) {
  split <- strsplit(expr, "%in%")[[1]] |>
    trimws()
  left <- split[1]
  right <- split[2]
  new_right <- paste0("$is_in(pl$lit(", right, "))")
  paste0(left, new_right)
}
