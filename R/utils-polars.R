#' Get column names of a Polars Data/LazyFrame
#'
#' @param x A Polars Data/LazyFrame
#'
#' @return A character vector with the column names
#' @noRd

pl_colnames <- function(x) {
  if (inherits(x, "DataFrame") || inherits(x, "LazyFrame")) {
    x$columns
  }
}

check_polars_data <- function(x) {
  if (!inherits(x, "DataFrame") && !inherits(x, "LazyFrame")) {
    rlang::abort(
      "The data must be a Polars DataFrame or LazyFrame.",
      call = caller_env()
    )
  }
}

check_same_class <- function(x, y) {
  if (class(x) != class(y)) {
    rlang::abort(
      paste0(
        "Both objects must be of the same class. Currently, `x` is a ",
        class(x), " and `y` is a ", class(y), "."
      ),
      call = caller_env(2)
    )
  }
}
