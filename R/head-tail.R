# Needed for show_query(). This has to shadow polars' exports, otherwise there
# are cases where we cannot record the query at any time, e.g.:
# mtcars |> as_polars_df() |> head() |> show_query()
#' @export
head.polars_data_frame <- function(x, n = 6L, ...) {
  x <- tag_frame(x, substitute(x))
  x$head(n = n)
}

#' @export
head.polars_lazy_frame <- head.polars_data_frame

#' @export
tail.polars_data_frame <- function(x, n = 6L, ...) {
  x <- tag_frame(x, substitute(x))
  x$tail(n = n)
}

#' @export
tail.polars_lazy_frame <- tail.polars_data_frame
