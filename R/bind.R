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
  dots <- get_dots(...)
  one_el <- length(dots) == 1L

  dots <- lapply(dots, \(x) eval(x, envir = parent.frame(4L)))
  dots_is_a_single_list <- one_el && is.list(dots)

  if (dots_is_a_single_list) dots <- unlist(dots)

  all_dataframe <- all(vapply(dots, \(y) {
    inherits(y, "DataFrame")
  }, FUN.VALUE = logical(1L)))

  all_lazyframe <- all(vapply(dots, \(y) {
    inherits(y, "LazyFrame")
  }, FUN.VALUE = logical(1L)))

  if (!all_lazyframe && !all_dataframe) {
    stop("All elements in `...` must be of the same class (either DataFrame or LazyFrame).")
  }

  pl$concat(dots, how = how)
}
