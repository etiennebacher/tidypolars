#' Show the polars query equivalent to the tidyverse code
#'
#' This function converts the tidyverse query into Polars code.
#'
#' @inheritParams count.RPolarsDataFrame
#' @param ... Not used.
#'
#' @return Prints the polars code in the console and invisibly returns the
#' query as a character vector.
#'
#' @export
#'
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' tidy <- mtcars |>
#'   as_polars_df() |>
#'   arrange(drat, -cyl) |>
#'   add_count(am, gear) |>
#'   drop_na()
#'
#' # the polars code is printed and assigned to `query`
#' query <- show_query(tidy)
#'
#' query

show_query.tidypolars <- function(x, ...) {
  attrs <- attributes(x)$polars_expression
  out <- lapply(seq_along(attrs), function(x) {
    e <- attrs[[x]]
    e <- gsub("^[^\\$]+\\$", "$", e)
    gsub("^\\$", "$\\\n  ", e)
  }) |>
    unlist() |>
    paste(collapse = "")

  class(out) <- c("tidypolars_query", class(out))
  invisible(out)
}

#' @exportS3Method
print.tidypolars_query <- function(x) {
  x <- paste0("<data>", x)
  cat("Pure polars expression:\n\n")
  cat(x)
}
