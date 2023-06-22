#' Group by one or more variables
#'
#' Most data operations are done on groups defined by variables. `pl_group_by()`
#' takes an existing Polars Data/LazyFrame and converts it into a grouped one
#' where operations are performed "by group". `pl_ungroup()` removes grouping.
#'
#' @param data A Polars Data/LazyFrame
#' @param ... Variables to group by (used in `pl_group_by()` only).
#' @param maintain_order Maintain row order. This is the default but it can
#' slow down the process with large datasets and it prevents the use of
#' streaming.
#'
#' @export
#' @examples
#' by_cyl <- mtcars |>
#'   as_polars() |>
#'   pl_group_by(cyl)
#'
#' by_cyl
#'
#' by_cyl |> pl_summarise(
#'   disp = mean(disp),
#'   hp = mean(hp)
#' )
#' by_cyl |> pl_filter(disp == max(disp))
#'

pl_group_by <- function(data, ..., maintain_order = TRUE) {
  check_polars_data(data)
  vars <- .select_nse_from_dots(data, ...)

  # we can't access column names on a "GroupBy" object so I save them as an
  # attribute before
  names <- pl_colnames(data)
  data <- data$groupby(vars, maintain_order = maintain_order)
  attr(data, "pl_colnames") <- names
  attr(data, "pl_grps") <- vars
  data
}

#' @rdname pl_group_by
#' @export

pl_ungroup <- function(data) {
  if (inherits(data, "GroupBy")) {
    class(data) <- "DataFrame"
    attributes(data)$pl_grps <- NULL
  } else {
    if (inherits(data, "LazyGroupBy")) {
      class(data) <- "LazyFrame"
      attributes(data)$pl_grps <- NULL
    }
  }
  data
}
