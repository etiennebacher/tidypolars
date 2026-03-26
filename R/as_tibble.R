#' @export
as_tibble.tidypolars <- function(x, ...) {
  # Don't need get_grps() since we don't have to handle a ".by" argument here,
  # and this is faster.
  grps <- attributes(x)$pl_grps
  is_grouped <- !is.null(grps)

  # Call the method defined in polars
  out <- NextMethod()

  if (is_grouped) {
    out <- out |>
      group_by(across(all_of(grps)))
  }

  out
}
