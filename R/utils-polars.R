#' Get column names of a Polars Data/LazyFrame
#'
#' @param x A Polars Data/LazyFrame or GroupBy/LazyGroupBy
#'
#' @return A character vector with the column names
#' @export
pl_colnames <- function(x) {
  if (inherits(x, "DataFrame") | inherits(x, "LazyFrame")) {
    x$columns
  } else if (inherits(x, "GroupBy") | inherits(x, "LazyGroupBy")) {
    attr(x, "pl_colnames", exact = TRUE)
  }
}

check_polars_data <- function(x) {
  if (!inherits(x, "DataFrame") && !inherits(x, "LazyFrame")
      && !inherits(x, "GroupBy") && !inherits(x, "LazyGroupBy")) {
    stop("The data must be a Polars DataFrame or LazyFrame.")
  }
}

check_same_class <- function(x, y) {
  if (class(x) != class(y)) {
    stop(
      paste0(
        "Both objects must be of the same class. Currently, `x` is a ",
        class(x), " and `y` is a ", class(y), "."
      )
    )
  }
}

pl_groups <- function(x) {
  if (inherits(x, "GroupBy") | inherits(x, "LazyGroupBy")) {
    attributes(x)$pl_grps
  }
}

clone_grouped_data <- function(x) {
  if (inherits(x, "GroupBy") || inherits(x, "LazyGroupBy")) {
    x
  } else {
    NULL
  }
}
