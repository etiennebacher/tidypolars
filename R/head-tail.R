# TODO: Negative n is not yet supported by r-polars LazyFrame head()/tail().
# Wait for upstream support before enabling the negative-n lazy tests.

# Needed for show_query(). This has to shadow polars' exports, otherwise there
# are cases where we cannot record the query at any time, e.g.:
# mtcars |> as_polars_df() |> head() |> show_query()
#' @export
head.polars_data_frame <- function(x, n = 6L, ...) {
  x <- tag_frame(x, substitute(x))
  grps <- attributes(x)$pl_grps
  mo <- attributes(x)$maintain_grp_order %||% FALSE

  out <- x$head(n = n)

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

  out <- x$tail(n = n)

  if (!is.null(grps)) {
    out <- group_by(out, all_of(grps), maintain_order = mo)
  }
  add_tidypolars_class(out)
}

#' @export
tail.polars_lazy_frame <- tail.polars_data_frame
