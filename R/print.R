#' Print method for DataFrame
#'
#' @param x A Polars DataFrame
#' @param ... Not used
#'
#' @export
#' @noRd

print.tidypolars <- function(x, ...) { # nocov start
  grps <- attributes(x)$pl_grps
  is_grouped <- !is.null(grps)
  mo <- attributes(x)$maintain_grp_order %||% FALSE
  rowwise <- attributes(x)$grp_type == "rowwise"

  x$print()

  if (is_grouped && inherits(x, "RPolarsDataFrame")) {
    n_groups <- x$group_by(grps)$agg(pl$lit(1))$height
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
