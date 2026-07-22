check_polars_data <- function(x, env = caller_env()) {
  if (!is_polars_df(x) && !is_polars_lf(x)) {
    cli_abort(
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

# Run a Polars operation, replacing its nested error chain by the root message
# so that users see the actionable error and not the "Evaluation failed in
# `$...()`" wrappers.
with_polars_errors <- function(expr, call = caller_env()) {
  tryCatch(
    expr,
    error = function(e) {
      # Get the innermost error message, the one reported by rust-polars and not
      # all the r-polars wrappers.
      while (!is.null(e$parent)) {
        e <- e$parent
      }
      error <- paste(c(conditionMessage(e), e$body), collapse = "\n")
      # cli collapses newlines into spaces, so we use cli's hard line breaks instead (\f)
      error <- gsub("\n+", "\f", error)
      cli_abort("{error}", call = call)
    }
  )
}
