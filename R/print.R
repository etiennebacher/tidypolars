#' Print method for DataFrame
#'
#' @param x A Polars DataFrame
#' @param ... Not used
#'
#' @export
print.DataFrame <- function(x, ...) {
  grps <- attributes(x)$pl_grps
  is_grouped <- !is.null(grps)
  mo <- attributes(x)$maintain_grp_order

  x$print()

  if (is_grouped) {
    cat(paste0("Groups: ", toString(grps), "\n"))
    cat(paste0("Maintain order: ", mo))
    invisible(x)
  }
}
