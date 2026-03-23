#' Count the observations in each group
#'
#' @param x A Polars Data/LazyFrame
#' @inheritParams fill.polars_data_frame
#' @param sort If `TRUE`, will show the largest groups at the top.
#' @param name Name of the new column.
#' @param wt Not supported by tidypolars.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars::as_polars_df(mtcars)
#'
#' # grouping variables must be specified in count() and add_count()
#' count(test, cyl)
#' count(test, cyl, am)
#' count(test, cyl, am, sort = TRUE, name = "count")
#'
#' add_count(test, cyl, am, sort = TRUE, name = "count")
#'
#' # tally() directly uses grouping variables of the input
#' test |>
#'   group_by(cyl) |>
#'   tally()
#'
#' test |>
#'   group_by(cyl, am) |>
#'   tally(sort = TRUE, name = "count")
count.polars_data_frame <- function(
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
  mo <- attributes(x)$maintain_grp_order %||% FALSE
  is_grouped <- !is.null(grps)

  polars_exprs <- translate_dots(
    x,
    ...,
    env = rlang::current_env(),
    caller = rlang::caller_env()
  )

  # Only unnamed inputs
  if (!is.null(names(polars_exprs))) {
    polars_exprs <- lapply(polars_exprs, \(x) {
      lapply(x, function(y) {
        if (length(y) == 0) {
          cli_abort(
            "{.pkg tidypolars} doesn't support both named and unnamed inputs in {.fn count}.",
            call = rlang::caller_env(4)
          )
        }
        y
      })
    })
    names(polars_exprs) <- NULL
    polars_exprs <- unlist(polars_exprs, recursive = FALSE)
  }

  if (length(polars_exprs) == 0) {
    if (is_grouped) {
      out <- x$group_by(grps)$len()$rename(len = name)
      if (isTRUE(sort)) {
        out <- out$sort(
          name,
          grps,
          descending = c(TRUE, rep(FALSE, length(grps)))
        )
      } else {
        out <- out$sort(grps)
      }
      out <- group_by(out, all_of(grps), maintain_order = mo)
    } else {
      out <- x$group_by(`__tidypolars_grp__` = pl$lit(1))$len()$drop(
        "__tidypolars_grp__"
      )$rename(len = name)
    }

    return(add_tidypolars_class(out))
  }

  if (is.null(names(polars_exprs))) {
    new_names <- enexprs(...)
    new_names <- lapply(new_names, expr_deparse)
    names(polars_exprs) <- unlist(new_names, use.names = FALSE)
  }

  name <- check_count_name(x, names(x), name)

  if (is_grouped) {
    # If there are some duplicates in grps and names(polars_exprs), we want to
    # favor the value in names(polars_exprs), but the column order of the
    # output should follow the order of grps and then names(polars_exprs).
    grps2 <- grps[!(grps %in% names(polars_exprs))]
    names_polars_exprs2 <- names(polars_exprs)[!(names(polars_exprs) %in% grps)]
    if (length(grps2) > 0) {
      out <- x$group_by(grps2, !!!polars_exprs)$len()$rename(len = name)$select(
        grps,
        names_polars_exprs2,
        name
      )
    } else {
      out <- x$group_by(!!!polars_exprs)$len()$rename(len = name)
    }
  } else {
    out <- x$group_by(!!!polars_exprs)$len()$rename(len = name)
  }

  if (isTRUE(sort)) {
    if (is_grouped) {
      out <- out$sort(
        name,
        grps,
        !!!names(polars_exprs),
        descending = c(TRUE, rep(FALSE, length(grps) + length(polars_exprs)))
      )
    } else {
      out <- out$sort(
        name,
        !!!names(polars_exprs),
        descending = c(TRUE, rep(FALSE, length(polars_exprs)))
      )
    }
  } else {
    out <- out$sort(grps, !!!names(polars_exprs))
  }

  if (is_grouped) {
    out <- group_by(out, all_of(grps), maintain_order = mo)
  }

  add_tidypolars_class(out)
}

#' @rdname count.polars_data_frame
#' @export
tally.polars_data_frame <- function(x, wt = NULL, sort = FALSE, name = "n") {
  if (!missing(wt)) {
    check_unsupported_arg(wt = quo_text(enquo(wt)))
  }
  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order %||% FALSE
  is_grouped <- !is.null(grps)
  out <- count_(x, grps, sort = sort, name = name, new_col = FALSE)

  if (length(grps) > 1) {
    grps <- grps[-length(grps)]
    out <- group_by(out, all_of(grps), maintain_order = mo)
  }

  add_tidypolars_class(out)
}

#' @rdname count.polars_data_frame
#' @export
count.polars_lazy_frame <- count.polars_data_frame

#' @rdname count.polars_data_frame
#' @export
tally.polars_lazy_frame <- tally.polars_data_frame

#' @rdname count.polars_data_frame
#' @export
add_count.polars_data_frame <- function(
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
  mo <- attributes(x)$maintain_grp_order %||% FALSE
  is_grouped <- !is.null(grps)

  polars_exprs <- translate_dots(
    x,
    ...,
    env = rlang::current_env(),
    caller = rlang::caller_env()
  )

  # Only unnamed inputs
  if (!is.null(names(polars_exprs))) {
    polars_exprs <- lapply(polars_exprs, \(x) {
      lapply(x, function(y) {
        if (length(y) == 0) {
          cli_abort(
            "{.pkg tidypolars} doesn't support both named and unnamed inputs in {.fn count}.",
            call = rlang::caller_env(4)
          )
        }
        y
      })
    })
    names(polars_exprs) <- NULL
    polars_exprs <- unlist(polars_exprs, recursive = FALSE)
  }

  if (length(polars_exprs) == 0) {
    if (is_grouped) {
      out <- x$with_columns(pl$len()$over(!!!grps)$alias(name))
      if (isTRUE(sort)) {
        out <- out$sort(
          name,
          grps,
          descending = c(TRUE, rep(FALSE, length(grps)))
        )
      }
      out <- group_by(out, all_of(grps), maintain_order = mo)
    } else {
      out <- x$with_columns(pl$len()$alias(name))
    }

    return(add_tidypolars_class(out))
  }

  if (is.null(names(polars_exprs))) {
    new_names <- enexprs(...)
    new_names <- lapply(new_names, expr_deparse)
    names(polars_exprs) <- unlist(new_names, use.names = FALSE)
  }

  name <- check_count_name(x, names(x), name)

  x <- x$with_columns(!!!polars_exprs)

  if (is_grouped) {
    grps2 <- grps[!(grps %in% names(polars_exprs))]
    if (length(grps2) > 0) {
      out <- x$with_columns(pl$len()$over(grps2, !!!names(polars_exprs))$alias(
        name
      ))
    } else {
      out <- x$with_columns(pl$len()$over(!!!names(polars_exprs))$alias(name))
    }
  } else {
    out <- x$with_columns(pl$len()$over(!!!names(polars_exprs))$alias(name))
  }

  if (isTRUE(sort)) {
    if (is_grouped) {
      out <- out$sort(
        name,
        grps,
        !!!names(polars_exprs),
        descending = c(TRUE, rep(FALSE, length(grps) + length(polars_exprs)))
      )
    } else {
      out <- out$sort(name, descending = TRUE)
    }
  }

  if (is_grouped) {
    out <- group_by(out, all_of(grps), maintain_order = mo)
  }

  add_tidypolars_class(out)
}

#' @rdname count.polars_data_frame
#' @export
add_count.polars_lazy_frame <- add_count.polars_data_frame

count_ <- function(x, vars, sort, name, new_col = FALSE, missing_name = FALSE) {
  name <- check_count_name(x, vars, name, missing_name)
  if (isTRUE(new_col)) {
    if (length(vars) == 0) {
      out <- x$with_columns(
        pl$len()$alias(name)
      )
    } else {
      out <- x$with_columns(
        pl$len()$alias(name)$over(!!!vars)
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
      out <- x$group_by(vars, .maintain_order = FALSE)$agg(
        pl$len()$alias(name)
      )
    }
  }

  if (isTRUE(sort)) {
    if (isFALSE(new_col) && length(vars) > 0) {
      out$sort(name, !!!vars, descending = c(TRUE, rep(FALSE, length(vars))))
    } else {
      out$sort(name, descending = TRUE)
    }
  } else if (isFALSE(new_col) && length(vars) > 0) {
    out$sort(vars)
  } else {
    out
  }
}

check_count_name <- function(x, vars, name) {
  new_name <- name

  while (new_name %in% vars) {
    new_name <- paste0(new_name, "n")
  }
  if (new_name != name) {
    cli_inform(
      c(
        "Storing counts in {.code {new_name}}, as {.code n} already present in input.",
        "i" = "Use {.code name = \"new_name\"} to pick a new name."
      )
    )
  }

  new_name
}
