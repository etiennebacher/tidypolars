#' @export
pl_colnames <- function(x) {
  if (inherits(x, "DataFrame")) {
    x$columns
  } else if (inherits(x, "LazyFrame")) {
    # TODO: not happy with that because it forces to collect something
    # that potentially has a lot of operations before
    # but maybe the optimization performs the slice first so it doesn't matter?
    x$slice(0, 1)$collect()$columns
  } else if (inherits(x, "GroupBy")) {
    attr(x, "pl_colnames", exact = TRUE)
  }
}

check_polars_data <- function(x) {
  if (!inherits(x, "DataFrame") && !inherits(x, "LazyFrame")
      && !inherits(x, "GroupBy")) {
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

clone_grouped_data <- function(x) {
  if (inherits(x, "GroupBy") | inherits(x, "LazyGroupBy")) {
    x
  } else {
    NULL
  }
}
