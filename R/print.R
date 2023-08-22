#' Print method for DataFrame
#'
#' @param x A Polars DataFrame
#' @param ... Not used
#'
#' @export
print.DataFrame <- function(x, ...) { # nocov start
  grps <- attributes(x)$pl_grps
  is_grouped <- !is.null(grps)
  mo <- attributes(x)$maintain_grp_order
  rowwise <- attributes(x)$grp_type == "rowwise"

  if (is_grouped) {
    n_groups <- x$groupby(grps)$agg(pl$lit(1))$height
  }

  x$print()

  if (is_grouped) {
    cat(paste0(
      "Groups [", format(n_groups, big.mark = ","), "]: ",
      toString(grps), "\n")
    )
    cat(paste0("Maintain order: ", mo))
  }

  if (isTRUE(rowwise)) {
    cat("\nRowwise: TRUE\n")
  }
}
# nocov end
