#' Stack multiple Data/LazyFrames on top of each other
#'
#' @param ... Polars DataFrames or LazyFrames to combine. Each argument can
#'  either be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
#'  by name. All Data/LazyFrames must have the same number of columns with
#'  identical names.
#'
#' @export
#' @examples
#' p1 <- polars::pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#' p2 <- polars::pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#'
#' pl_bind_rows(p1, p2)
#'
#' # this is equivalent
#' pl_bind_rows(list(p1, p2))

pl_bind_rows <- function(...) {
  # TODO: check with "diagonal" to coerce types and fill missings
  # wait for https://github.com/pola-rs/r-polars/issues/350
  concat_(..., how = "vertical")
}

#' Append multiple Data/LazyFrames next to each other
#'
#' @param ... Polars DataFrames or LazyFrames to combine. Each argument can
#'  either be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
#'  by name. All Data/LazyFrames must have the same number of rows and there
#'  mustn't be duplicated column names.
#'
#' @export
#' @examples
#' p1 <- polars::pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#' p2 <- polars::pl$DataFrame(
#'   z = sample(letters, 20),
#'   w = sample(1:100, 20)
#' )
#'
#' pl_bind_cols(p1, p2)
#' pl_bind_cols(list(p1, p2))

pl_bind_cols <- function(...) {
  concat_(..., how = "horizontal")
}

concat_ <- function(..., how) {
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

  pl$concat(dots, how = how)
}
