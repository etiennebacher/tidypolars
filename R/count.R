#' Count the observations in each group
#'
#' @param x A Polars Data/LazyFrame
#' @inheritParams fill.RPolarsDataFrame
#' @param sort If `TRUE`, will show the largest groups at the top.
#' @param name Name of the new column.
#' @param wt Not supported by tidypolars.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars::as_polars_df(mtcars)
#' count(test, cyl)
#'
#' count(test, cyl, am)
#'
#' count(test, cyl, am, sort = TRUE, name = "count")
#'
#' add_count(test, cyl, am, sort = TRUE, name = "count")
count.RPolarsDataFrame <- function(
  x,
  ...,
  wt = NULL,
  sort = FALSE,
  name = "n"
) {
  if (!missing(wt)) {
    check_unsupported_arg(wt = quo_text(enquo(wt)))
  }
  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order
  is_grouped <- !is.null(grps)

  vars <- tidyselect_dots(x, ...)
  vars <- c(grps, vars)
  out <- count_(x, vars, sort = sort, name = name, new_col = FALSE)

  out <- if (is_grouped) {
    group_by(out, all_of(grps), maintain_order = mo)
  } else {
    out
  }

  add_tidypolars_class(out)
}

#' @rdname count.RPolarsDataFrame
#' @export
count.RPolarsLazyFrame <- count.RPolarsDataFrame

#' @rdname count.RPolarsDataFrame
#' @export

add_count.RPolarsDataFrame <- function(
  x,
  ...,
  wt = NULL,
  sort = FALSE,
  name = "n"
) {
  if (!missing(wt)) {
    check_unsupported_arg(wt = quo_text(enquo(wt)))
  }
  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order
  is_grouped <- !is.null(grps)

  vars <- tidyselect_dots(x, ...)
  vars <- c(grps, vars)
  out <- count_(
    x,
    vars,
    sort = sort,
    name = name,
    new_col = TRUE,
    missing_name = missing(name)
  )

  out <- if (is_grouped) {
    group_by(out, all_of(grps), maintain_order = mo)
  } else {
    out
  }

  add_tidypolars_class(out)
}

#' @rdname count.RPolarsDataFrame
#' @export
add_count.RPolarsLazyFrame <- add_count.RPolarsDataFrame

count_ <- function(x, vars, sort, name, new_col = FALSE, missing_name = FALSE) {
  name <- check_name(x, vars, name, missing_name)
  if (isTRUE(new_col)) {
    if (length(vars) == 0) {
      out <- x$with_columns(
        pl$len()$alias(name)
      )
    } else {
      out <- x$with_columns(
        pl$len()$alias(name)$over(vars)
      )
    }
  } else {
    if (length(vars) == 0) {
      out <- x$select(
        pl$len()$alias(name)
      )
    } else {
      # https://github.com/etiennebacher/tidypolars/issues/193
      vars <- unique(vars)
      out <- x$group_by(vars, maintain_order = FALSE)$agg(
        pl$len()$alias(name)
      )
    }
  }

  if (isTRUE(sort)) {
    out$sort(name, descending = TRUE)
  } else if (length(vars) > 0) {
    out$sort(vars)
  } else {
    out
  }
}

check_name <- function(x, vars, name, missing_name) {
  new_name <- name
  if (isTRUE(missing_name)) {
    while (new_name %in% names(x)) {
      new_name <- paste0(new_name, "n")
    }
    if (new_name != name) {
      rlang::inform(
        c(
          paste0(
            "Storing counts in `",
            new_name,
            "`, as `n` already present in input."
          ),
          "i" = "Use `name = \"new_name\"` to pick a new name."
        )
      )
    }
  } else {
    while (new_name %in% vars) {
      new_name <- paste0(new_name, "n")
    }
    if (new_name != name) {
      rlang::inform(
        c(
          paste0(
            "Storing counts in `",
            new_name,
            "`, as `n` already present in input."
          ),
          "i" = "Use `name = \"new_name\"` to pick a new name."
        )
      )
    }
  }

  new_name
}
