#' @export
as_tibble.tidypolars <- function(x, ...) {
  grps <- get_grps(x, NULL, env = rlang::current_env())
  is_grouped <- !is.null(grps)

  # Call the method defined in polars
  out <- NextMethod()

  if (is_grouped) {
    out <- out |>
      group_by(across(all_of(grps)))
  }

  out
}
