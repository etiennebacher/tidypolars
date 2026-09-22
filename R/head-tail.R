# Needed for show_query(). This has to shadow polars' exports, otherwise there
# are cases where we cannot record the query at any time, e.g.:
# mtcars |> as_polars_df() |> head() |> show_query()
#' @export
head.polars_data_frame <- function(x, n = 6L, ...) {
  x <- tag_frame(x, substitute(x))
  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order %||% FALSE

  out <- if (is_polars_lf(x) && isTRUE(n < 0)) {
    x$reverse()$slice(-n)$reverse()
  } else {
    x$head(n = n)
  }

  if (!is.null(grps)) {
    out <- group_by(out, all_of(grps), maintain_order = mo)
  }
  add_tidypolars_class(out)
}

#' @export
head.polars_lazy_frame <- head.polars_data_frame

#' @export
tail.polars_data_frame <- function(x, n = 6L, ...) {
  x <- tag_frame(x, substitute(x))
  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order %||% FALSE

  out <- if (is_polars_lf(x) && isTRUE(n < 0)) {
    x$slice(-n)
  } else {
    x$tail(n = n)
  }

  if (!is.null(grps)) {
    out <- group_by(out, all_of(grps), maintain_order = mo)
  }
  add_tidypolars_class(out)
}

#' @export
tail.polars_lazy_frame <- tail.polars_data_frame
