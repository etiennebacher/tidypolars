check_polars_data <- function(x, env = caller_env()) {
  if (!inherits(x, "RPolarsDataFrame") && !inherits(x, "RPolarsLazyFrame")) {
    rlang::abort(
      "The data must be a Polars DataFrame or LazyFrame.",
      call = env
    )
  }
}

add_tidypolars_class <- function(x) {
  if (!inherits(x, "tidypolars")) {
    class(x) <- c("tidypolars", class(x))
  }
  x
}
