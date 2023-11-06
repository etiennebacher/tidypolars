#' Stack multiple Data/LazyFrames on top of each other
#'
#' @param ... Polars DataFrames or LazyFrames to combine. Each argument can
#'  either be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
#'  by name. All Data/LazyFrames must have the same number of columns with
#'  identical names.
#' @param .id The name of an optional identifier column. Provide a string to
#' create an output column that identifies each input.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' p1 <- polars::pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#' p2 <- polars::pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#'
#' bind_rows_polars(p1, p2)
#'
#' # this is equivalent
#' bind_rows_polars(list(p1, p2))
#'
#' # create an id colum
#' bind_rows_polars(p1, p2, .id = "id")

bind_rows_polars <- function(..., .id = NULL) {
  # TODO: check with "diagonal" to coerce types and fill missings
  # wait for https://github.com/pola-rs/r-polars/issues/350
  concat_(..., how = "vertical", .id = .id)
}

#' Append multiple Data/LazyFrames next to each other
#'
#' @param ... Polars DataFrames or LazyFrames to combine. Each argument can
#'  either be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
#'  by name. All Data/LazyFrames must have the same number of rows and there
#'  mustn't be duplicated column names.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' p1 <- polars::pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#' p2 <- polars::pl$DataFrame(
#'   z = sample(letters, 20),
#'   w = sample(1:100, 20)
#' )
#'
#' bind_cols_polars(p1, p2)
#' bind_cols_polars(list(p1, p2))

# bind_* functions are not generics: https://github.com/tidyverse/dplyr/issues/6905

bind_cols_polars <- function(...) {
  concat_(..., how = "horizontal")
}

concat_ <- function(..., how, .id = NULL) {
  dots <- rlang::list2(...)
  if (length(dots) == 1 && rlang::is_bare_list(dots[[1]])) {
    dots <- dots[[1]]
  }

  any_not_polars <- any(vapply(dots, \(y) {
    !inherits(y, "DataFrame") && !inherits(y, "LazyFrame")
  }, FUN.VALUE = logical(1L)))

  if (any_not_polars) {
    rlang::abort(
      "All elements in `...` must be either DataFrames or LazyFrames).",
      call = caller_env()
    )
  }

  all_df_or_lf <- all(vapply(dots, \(y) {
    inherits(y, "DataFrame") || inherits(y, "LazyFrame")
  }, FUN.VALUE = logical(1L)))

  if (!all_df_or_lf) {
    rlang::abort(
      "All elements in `...` must be of the same class (either DataFrame or LazyFrame).",
      call = caller_env()
    )
  }

  if (!is.null(.id)) {
    dots <- lapply(seq_along(dots), \(x) {
      dots[[x]]$
        with_columns(
          pl$lit(x)$alias(.id)
        )$
        select(pl$col(.id), pl$col("*")$exclude(.id))
    })
  }

  pl$concat(dots, how = how)
}
